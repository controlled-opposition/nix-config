{ inputs, lib, ... }:

let
  pstackSource = inputs.pstack + "/pstack/skills";

  pstackSkills = lib.filterAttrs (name: type: type == "directory") (builtins.readDir pstackSource);

  pstackSkillFiles = builtins.listToAttrs (
    map (
      skill:
      lib.nameValuePair ".codex/skills/${skill}" {
        source = pstackSource + "/${skill}";
      }
    ) (builtins.attrNames pstackSkills)
  );
in
{
  files = pstackSkillFiles;
}
