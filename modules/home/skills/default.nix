{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  categories = [
    "engineering"
    "productivity"
  ];

  skillsIn =
    root:
    let
      directories = lib.filterAttrs (_: type: type == "directory") (builtins.readDir root);
      skills = lib.filterAttrs (name: _: builtins.pathExists "${root}/${name}/SKILL.md") directories;
      containers = lib.filterAttrs (name: _: !(builtins.hasAttr name skills)) directories;
      nestedSkills = lib.foldl' (found: name: found // skillsIn "${root}/${name}") { } (
        builtins.attrNames containers
      );
    in
    lib.mapAttrs (name: _: "${root}/${name}") skills // nestedSkills;

  localSkills = skillsIn ./files;
  remoteByCategory = map (
    category: skillsIn "${inputs.mattpocock-skills}/skills/${category}"
  ) categories;
  remoteSkillNames = lib.concatMap builtins.attrNames remoteByCategory;
  remoteSkills = lib.foldl' (skills: source: skills // source) { } remoteByCategory;

  sharedLocalSkills = lib.filterAttrs (
    name: _:
    builtins.elem name [
      "nh"
      "home-manager-rebuild"
    ]
  ) localSkills;

  skillsByTarget = {
    ".claude/skills" = remoteSkills // localSkills;
    ".codex/skills" = remoteSkills // sharedLocalSkills;
    ".pi/agent/skills" = remoteSkills // sharedLocalSkills;
  };

  skillFiles = lib.foldl' (
    files: target:
    files
    // lib.mapAttrs' (
      name: source:
      lib.nameValuePair "${target}/${name}" {
        inherit source;
        force = true;
      }
    ) skillsByTarget.${target}
  ) { } (builtins.attrNames skillsByTarget);

  homeFilesPrefix = lib.escapeShellArg "${builtins.storeDir}/";

  collisionChecks = lib.concatStringsSep "\n" (
    lib.concatLists (
      lib.mapAttrsToList (
        target: skills:
        map (name: ''
          target="$HOME"/${lib.escapeShellArg "${target}/${name}"}
          if [ -e "$target" ] || [ -L "$target" ]; then
            if [ ! -L "$target" ]; then
              printf '%s\\n' "Refusing to replace unmanaged skill path: $target" >&2
              exit 1
            fi
            current_source="$(readlink "$target")"
            case "$current_source" in
              ${homeFilesPrefix}*-home-manager-files/*) ;;
              *)
                printf '%s\\n' "Refusing to replace unmanaged skill link: $target -> $current_source" >&2
                exit 1
                ;;
            esac
          fi
        '') (builtins.attrNames skills)
      ) skillsByTarget
    )
  );
in
assert builtins.length remoteSkillNames == builtins.length (lib.unique remoteSkillNames);
assert builtins.attrNames (lib.intersectAttrs localSkills remoteSkills) == [ ];
{
  home.file = skillFiles;

  home.activation.migrateAgentSkills =
    lib.hm.dag.entryBetween [ "linkGeneration" ] [ "writeBoundary" ]
      ''
        marker_name=".agent-skills-managed.json"
        jq=${lib.escapeShellArg (lib.getExe pkgs.jq)}

        is_agent_skills_managed() {
          [ -d "$1" ] && [ ! -L "$1" ] \
            && [ -f "$1/$marker_name" ] && [ ! -L "$1/$marker_name" ] \
            && "$jq" -e '.schemaVersion == 1 and .managedBy == "agent-skills-nix"' "$1/$marker_name" >/dev/null 2>&1
        }

        is_partial_agent_skills_tree() {
          [ -d "$1" ] && [ ! -L "$1" ] || return 1

          for entry in "$1"/*; do
            [ -e "$entry" ] || [ -L "$entry" ] || continue
            case "$entry" in
              "$1/engineering" | "$1/productivity") ;;
              *) return 1 ;;
            esac
          done

          for category in engineering productivity; do
            category_dir="$1/$category"
            [ -d "$category_dir" ] && [ ! -L "$category_dir" ] || return 1
            has_skills=0
            for skill in "$category_dir"/*; do
              [ -e "$skill" ] || [ -L "$skill" ] || continue
              [ -L "$skill" ] || return 1
              skill_source="$(readlink "$skill")" || return 1
              case "$skill_source" in
                /nix/store/*-agent-skills-source-*-safe/"$category"/*) ;;
                *) return 1 ;;
              esac
              has_skills=1
            done
            [ "$has_skills" = 1 ] || return 1
          done
        }

        for skills_dir in \
          "$HOME/.claude/skills" \
          "$HOME/.codex/skills" \
          "$HOME/.pi/agent/skills"
        do
          if is_agent_skills_managed "$skills_dir" || is_partial_agent_skills_tree "$skills_dir"; then
            verboseEcho "Removing legacy agent-skills-managed directory $skills_dir"
            run chmod $VERBOSE_ARG -R u+w "$skills_dir"
            run rm $VERBOSE_ARG -rf -- "$skills_dir"
          fi
        done

        if [ "''${DRY_RUN:-}" != 1 ]; then
          ${collisionChecks}
        fi
      '';
}
