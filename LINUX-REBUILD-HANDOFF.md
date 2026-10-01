# Linux rebuild and cache comparison handoff

## Goal for the next AI session

Repeat the cache, build-cost, closure-size, and Pi runtime comparisons on Linux. Read [AGENTS.md](AGENTS.md) first. Work from the repository root, preserve existing changes, keep dependency pins fixed, and report measurements before proposing configuration changes. Testing alone should not activate anything.

Identify the machine before selecting a configuration:

| Host | Standalone Home Manager target | Platform |
| --- | --- | --- |
| citrus | `rick@citrus` | `x86_64-linux` |
| rubus (WSL) | `weasel@rubus` | `x86_64-linux` |

## Decisions already made

- NVF was removed: input, module, imports, and lock dependencies. Do not restore it for this test.
- Both `pi` and `llm-agents` follow root nixpkgs in [flake.nix](flake.nix).
- Pi uses **`coding-agent-bun` from [lukasl-dev/pi.nix](https://github.com/lukasl-dev/pi.nix)**, not a custom recipe. Compare it with the same input's `coding-agent` npm/Node variant.
- The Bun switch was activated on `everick@malus`. Its installed wrapper executes Bun 1.4.2; process ancestry subsequently confirmed a live Pi session using Bun.
- `nodejs`, `bun`, and `uv` are declared once in [modules/home/common.nix](modules/home/common.nix). Git is enabled through [modules/home/git/default.nix](modules/home/git/default.nix), imported by the common module. Direct user Git entries and citrus's system-level Git enablement were removed.
- Linux configurations were evaluated, not built or activated on the Darwin machine.

Snapshot pins used for the measurements below (check current `flake.lock` before comparing):

| Input | Revision |
| --- | --- |
| Root nixpkgs, `nixos-unstable` | `b4fd65b198c599cbe814fcb9f42d25d021595ec9` |
| pi.nix | `a8331076564e00a753610240919889b845743bcf` |
| llm-agents.nix | `62003f27b430a6b3b1458724b9758f1e055f6d06` |
| pi.nix's own nixpkgs lock | `ef34387ddd751e1ab8857adf4676492d32eb24ec` |
| llm-agents' own nixpkgs lock, `nixpkgs-unstable` | `f45c6f04c2f013f004bf94e284e95d72898d9393` |

`follows` does not disable Cachix. It can change dependencies, derivations, and output paths. Cache alignment depends on the exact revision and package configuration, not merely `nixos-unstable` versus `nixpkgs-unstable`.

## Historical cache results

These were direct HTTP checks of exact output-hash `.narinfo` URLs, not Linux builds. Recheck: coverage can change even at fixed pins. A missing final output does not imply every dependency is uncached.

Pi 0.99.2, checked against `https://pi.cachix.org`:

| Platform / nixpkgs selection | npm (`coding-agent`) | Bun (`coding-agent-bun`) |
| --- | --- | --- |
| `aarch64-darwin`, root follows | Miss | Miss |
| `aarch64-darwin`, upstream lock | Miss | Miss |
| `x86_64-linux`, root follows | Miss | Miss |
| `x86_64-linux`, upstream lock | Hit | Hit |

llm-agents, checked against `https://cache.numtide.com`:

| Platform | Package | Root follows | Upstream lock |
| --- | --- | --- | --- |
| `aarch64-darwin` | Claude Code, Herdr, Hermes Agent | All hit | All hit |
| `x86_64-linux` | Claude Code 2.1.286 | Hit | Hit |
| `x86_64-linux` | Herdr 0.9.3 | Miss | Hit |
| `x86_64-linux` | Hermes Agent 2026.9.24 | Miss | Hit |

The initial recommendation to use llm-agents follows relied too heavily on Darwin. After checking Linux, keeping its upstream pin was recommended **if reliable Linux cache coverage is the priority**. The user has not requested that reversal; follows remains configured.

Cache configuration is in [modules/system/cache/default.nix](modules/system/cache/default.nix). **Citrus imports it; rubus currently does not.** Inspect the machine's applied Nix settings, substituters, trusted keys, and daemon trust restrictions. Direct HTTP hits do not prove the daemon will accept or use that cache. Do not silently change cache configuration or trust settings.

## Darwin measurements for comparison

Pi 0.99.2 with root follows, measured on `malus` (`aarch64-darwin`):

| Measurement | npm / Node 24.21.0 | Bun 1.4.2 |
| --- | --- | --- |
| `--version`, median | 316 ms | 193 ms |
| `--help`, median | 334 ms | 190 ms |
| RPC startup to successful `get_state`, median | 332 ms | 195 ms |
| Runtime closure, NAR sizes summed | 2.63 GiB / 183 paths | 0.70 GiB / 78 paths |
| Pi output alone | 380 MiB | 341 MiB |
| Final Pi derivation realization | 46 s (earlier rebuild sample) | 155 s |
| JavaScript build phase | 6.0 s | 3.4 s |

Startup tests used seven alternating runs, isolated empty HOME/agent directories, offline mode, and disabled extensions, skills, themes, prompt templates, and context files. Both variants passed version/help, RPC initialization, and native Canvas PNG generation. No provider calls, live MCP integrations, user extensions, or LLM throughput were tested.

Bun's first realization took **304 s**, with **431 derivations built** and a dry-run estimate of 404.5 MiB downloads / 1.6 GiB unpacked. Most derivations were dependency-cache entries. Its final Pi derivation spent approximately **110 s in fixup**, dominated by stripping. Faster JavaScript compilation did not mean a faster overall rebuild.

**The npm/Bun build samples were not matched cold builds.** npm reused dependencies and its `--rebuild` ended with an output-comparison failure; the existing output was retained. Bun's first build succeeded. Treat the 46 s npm figure as a derivation-task measurement, not a successful cold end-to-end build.

The installed Darwin Home Manager closure fell from 7.02 to 6.42 GiB after switching Pi, approximately 615 MiB. Shared dependencies make this reduction smaller than the standalone Pi closure difference.

Earlier profiling, before NVF removal and llm-agents follows:

- Cold evaluation: Darwin system 37.8 s, then Home Manager 56.2 s in the same initially empty diverted store. Root nixpkgs source materialization took 27.5 s; llm-agents' separate nixpkgs took 40.6 s.
- llm-agents cold closure probes took about 60 s, with zero cache misses; warm probes took about 0.5 s.
- npm Pi's substitution probe took 46.3 s, including 42.9 s copying its npm-dependencies output; two derivations were missing.
- NVF had 359 cache-missing derivations, including 323 Tree-sitter query derivations. This is historical motivation for removal, not a current dependency to benchmark.
- No fully cold successful end-to-end system build was measured. Independent phase/group times cannot be added because caches, shared dependencies, concurrency, and failures differ.

## Linux procedure

### 1. Record the baseline

Record hostname, user, CPU/RAM, native Linux versus WSL, `nix --version`, Git revision/status, current lock revisions, and effective cache settings. Use a temporary results directory outside the repository. Keep `flake.lock` unchanged. If pins differ from the snapshot, label results as a new experiment.

### 2. Evaluate both pin choices without editing the repository

This expression compares the configured inputs with the **same locked input sources loaded as standalone flakes**, which restore their own committed dependency locks. It does not compare against today's GitHub branch heads.

```sh
export BENCH="$(mktemp -d -t nix-linux-profile.XXXXXX)"
nix eval --impure --json --expr '
  let
    f = builtins.getFlake (toString ./.);
    system = "x86_64-linux";
    describe = input: names: builtins.listToAttrs (map (name: {
      inherit name;
      value = {
        drvPath = input.packages.${system}.${name}.drvPath;
        output = toString input.packages.${system}.${name};
        version = input.packages.${system}.${name}.version;
      };
    }) names);
    variants = input: names: {
      follows = describe input names;
      upstream = describe (builtins.getFlake
        (builtins.unsafeDiscardStringContext (toString input.outPath))) names;
    };
  in {
    pi = variants f.inputs.pi [ "coding-agent" "coding-agent-bun" ];
    llm-agents = variants f.inputs.llm-agents [ "claude-code" "herdr" "hermes-agent" ];
  }
' > "$BENCH/paths.json"
```

For each output, take the hash before the first `-` in its `/nix/store/<hash>-<name>` basename and fetch `<cache>/<hash>.narinfo`. Save the response body and HTTP status. Use Pi's cache for Pi and Numtide's cache for llm-agents. Record 200 as present, 404 as absent, and other statuses/network failures as inconclusive. Check whether both variants actually produce identical paths before drawing conclusions.

Completion: a fresh table covering all ten Linux outputs, their exact paths, versions, cache statuses, and the upstream nixpkgs revisions actually used.

### 3. Separate cache substitution from local compilation

Start with a dry run for each variant's evaluated derivation:

```sh
nix build --dry-run --no-link '/nix/store/<evaluated-derivation>.drv^out'
```

Use the real paths from `paths.json`. Save build/fetch counts and download estimates. Check which outputs are already locally valid; a no-op is not a build benchmark.

- **First realization:** time `nix build --no-link "$drv^out" -L --log-format internal-json`; save exit status and logs. Label the initial store state and enabled caches.
- **Warm-dependency rebuild:** `--rebuild` forces an already valid derivation to be rebuilt. Record comparison failures separately from build failures; preserve the existing outputs. This is not a cold build.
- **Fully cold probes:** use an isolated disposable VM/store and fresh evaluator/download caches, not deletion or garbage collection of the machine's live store. If sources/derivations are seeded, state exactly which. A cache probe using `max-jobs=0` fails at misses and is not a completed build. Check local Nix support for diverted stores/sandboxing before choosing this method.

For useful attribution, timestamp internal-JSON records with a monotonic clock, identify each `type=105` build activity, and track phase changes (`type=104` results). Report dependency preparation, final Pi task, JavaScript build, install, and fixup separately. Run heavy comparisons sequentially with fixed jobs/cores. Do not sum concurrent task durations as wall time.

Completion: timings, cache/build counts, phase attribution, exit statuses, and explicit cold/warm definitions for npm versus Bun and llm-agents follows versus upstream.

### 4. Compare Pi closures and startup

Build both Pi variants without installing them. Save `nix path-info --json --recursive "$out"`; sum `narSize` for the closure and also record the final output's own size. Compare shared versus exclusive paths before predicting Home Manager size savings.

Read the installed Pi version's CLI/RPC docs before writing the harness. Reproduce the seven-run alternating benchmark using each output's `bin/pi`, isolated empty HOME and `PI_CODING_AGENT_DIR`, no credentials, and offline mode. Disable automatic resources and context discovery. Measure `--version`, `--help`, and RPC `get_state` response latency with `--mode rpc --no-session`. Close stdin and confirm clean shutdown. Test Canvas by creating a small PNG under each package's actual runtime.

Record runtime executable/version. npm Pi uses a Node-oriented bundled CLI; Bun Pi uses an unbundled CLI and Bun runtime, so this compares the packaged variants, not only the JavaScript engines. Bun also uses Node/Python during the native Canvas build. Keep user-extension/MCP compatibility and model latency as separate tests requiring explicit scope and credential access.

If asked to verify the current AI session's runtime, inspect the ancestors of a command launched by that session and `/proc/<pid>/exe`. `which pi` and the installed wrapper establish what a future launch uses, not what the current process uses.

### 5. Report before changing configuration

Report the Linux cache table, build phases, closures, startup medians, smoke-test failures, and methodology limits alongside the historical Darwin results. Distinguish cached dependencies from cached final outputs. Make a recommendation separately for cache reliability, rebuild time, footprint, and compatibility.

Any later activation must target the matching Linux machine, with system activation before standalone Home Manager when both change; use the commands in [AGENTS.md](AGENTS.md). Confirm Git, Node, Bun, and uv remain available after applying the deduplication changes.

## Original local artifacts

These paths are on the Darwin machine and are **not repository files or expected to exist on Linux**:

- `/private/tmp/flake-rebuild-profile/`: original cold evaluation/cache probes and rebuild samples.
- `/private/tmp/llm-agents-cache-comparison/`: Darwin follows/upstream cache checks.
- `/private/tmp/llm-agents-linux-cache-comparison/`: Linux output paths and HTTP checks.
- `/private/tmp/pi-bun-comparison/`: `paths.json`, `cache-results.json`, timestamped build events/results, runtime results, closures, and `summary.json`.

The substantive findings and reproducible test plan are preserved here so the Linux AI session does not depend on those temporary artifacts.
