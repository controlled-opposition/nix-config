import { Buffer } from "node:buffer";
import {
	chmodSync,
	mkdtempSync,
	readFileSync,
	realpathSync,
	renameSync,
	rmSync,
	statSync,
	writeFileSync,
} from "node:fs";
import { basename, dirname, join } from "node:path";
import process from "node:process";

type Asset = { suffix: string; checksum: string };
type Update = { version: string; assets: Asset[] };

function ensure(condition: unknown, message: string): asserts condition {
	if (!condition) throw new Error(message);
}

function object(value: unknown): Record<string, unknown> {
	ensure(
		value !== null && typeof value === "object" && !Array.isArray(value),
		"expected an object in release metadata",
	);
	return value as Record<string, unknown>;
}

function string(value: unknown): string {
	ensure(typeof value === "string", "expected a string in release metadata");
	return value;
}

function releaseVersion(value: unknown): string {
	const version = string(value);
	ensure(
		/^[0-9]/.test(version) && !/[^0-9A-Za-z.+_-]/.test(version),
		`invalid release version: ${version}`,
	);
	return version;
}

async function get(url: string, headers: Record<string, string> = {}) {
	const response = await fetch(url, {
		headers,
		signal: AbortSignal.timeout(30_000),
	});
	ensure(response.ok, `${url}: HTTP ${response.status}`);
	return response.text();
}

async function manifest(url: string, headers?: Record<string, string>) {
	return object(JSON.parse(await get(url, headers)));
}

async function github(source: string, repo: string): Promise<Update> {
	const headers: Record<string, string> = {
		Accept: "application/vnd.github+json",
		"User-Agent": "nix-config-updater",
	};
	if (process.env.GITHUB_TOKEN) {
		headers.Authorization = `Bearer ${process.env.GITHUB_TOKEN}`;
	}
	const release = await manifest(
		`https://api.github.com/repos/${repo}/releases/latest`,
		headers,
	);
	const version = releaseVersion(string(release.tag_name).replace(/^v/, ""));
	ensure(Array.isArray(release.assets), `${repo}: missing release assets`);
	const available = new Map<string, Record<string, unknown>>();
	for (const value of release.assets) {
		const asset = object(value);
		const name = string(asset.name);
		ensure(!available.has(name), `${repo}: duplicate asset ${name}`);
		available.set(name, asset);
	}
	const assets: Asset[] = [];
	for (const [, name] of source.matchAll(
		/\/releases\/download\/v\$\{version\}\/([^"]+)"/g,
	)) {
		const filename = name.replaceAll(/\$\{version\}/g, () => version);
		const asset = available.get(filename);
		ensure(asset, `${repo}: missing asset ${filename}`);
		const digest = string(asset.digest);
		ensure(
			digest.startsWith("sha256:"),
			`${repo}: no sha256 digest for ${filename}`,
		);
		assets.push({ suffix: `/${name}`, checksum: digest.slice(7) });
	}
	return { version, assets };
}

async function claude(): Promise<Update> {
	const base =
		"https://storage.googleapis.com/claude-code-dist-86c565f3-f756-42ad-8dfa-d59b1c096819/claude-code-releases";
	const version = releaseVersion((await get(`${base}/latest`)).trim());
	const platforms = object(
		(await manifest(`${base}/${version}/manifest.json`)).platforms,
	);
	return {
		version,
		assets: ["linux-x64", "darwin-arm64"].map((platform) => ({
			suffix: `/${platform}/claude`,
			checksum: string(object(platforms[platform]).checksum),
		})),
	};
}

async function herdrApp(): Promise<Update> {
	const base = "https://releases.herdr.dev/app";
	const release = await manifest(`${base}/latest.json`);
	const version = releaseVersion(release.version);
	const targets = object(release.targets);
	return {
		version,
		assets: ["linux-x86_64", "macos-aarch64"].map((target) => {
			const asset = object(targets[target]);
			const suffix = `/herdr-app-${target}.tar.gz`;
			ensure(
				asset.url === `${base}/${version}${suffix}`,
				`herdr-app-bin: unexpected URL for ${target}`,
			);
			return { suffix, checksum: string(asset.sha256) };
		}),
	};
}

function replaceOnce(
	text: string,
	pattern: RegExp,
	replacement: (match: string, prefix: string) => string,
): string {
	let count = 0;
	const updated = text.replace(pattern, (match, prefix: string) => {
		count++;
		return replacement(match, prefix);
	});
	ensure(count === 1, `expected one match for ${pattern}, found ${count}`);
	return updated;
}

function updateSource(source: string, { version, assets }: Update): string {
	ensure(assets.length > 0, "no release assets found in source");
	const seen = new Set<string>();
	for (const { suffix, checksum } of assets) {
		ensure(!seen.has(suffix), `duplicate source asset: ${suffix}`);
		seen.add(suffix);
		ensure(
			checksum.length === 64 && /^[0-9a-fA-F]+$/.test(checksum),
			`invalid sha256 checksum for ${suffix}`,
		);
		const hash = `sha256-${Buffer.from(checksum, "hex").toString("base64")}`;
		const escaped = suffix.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
		source = replaceOnce(
			source,
			new RegExp(`(${escaped}";\\s*hash = ")[^"]+`, "g"),
			(_match, prefix) => prefix + hash,
		);
	}
	return replaceOnce(
		source,
		/(version = ")[^"]+"/g,
		(_match, prefix) => `${prefix}${version}"`,
	);
}

function save(file: string, source: string) {
	const mode = statSync(file).mode & 0o7777;
	const temporary = mkdtempSync(join(dirname(file), ".update-"));
	try {
		const target = join(temporary, basename(file));
		writeFileSync(target, source, { mode: 0o600 });
		chmodSync(target, mode);
		renameSync(target, file);
	} finally {
		rmSync(temporary, { recursive: true, force: true });
	}
}

async function main() {
	const args = process.argv.slice(2);
	const [provider, path, repo] = args;
	ensure(
		path &&
			((provider === "github" && repo && args.length === 3) ||
				(["claude", "herdr-app"].includes(provider ?? "") &&
					args.length === 2)),
		"usage: update-package <github|claude|herdr-app> <file> [owner/repo]",
	);
	const file = realpathSync(path);
	const source = readFileSync(file, "utf8");
	const update =
		provider === "github"
			? await github(source, string(repo))
			: provider === "claude"
				? await claude()
				: await herdrApp();
	const updated = updateSource(source, update);
	if (updated !== source) save(file, updated);
	const name =
		provider === "github"
			? repo
			: provider === "claude"
				? "claude-code-bin"
				: "herdr-app-bin";
	console.log(`${name}: ${update.version}`);
}

main().catch((error: unknown) => {
	console.error(error instanceof Error ? error.message : String(error));
	process.exitCode = 1;
});
