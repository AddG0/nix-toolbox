{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.claude.code;

  # Validate skill name: lowercase letters, numbers, and hyphens only (max 64 chars)
  validateSkillName = name: let
    validPattern = builtins.match "[a-z0-9-]+" name;
    validLength = stringLength name <= 64;
  in
    if validPattern == null
    then throw "Skill name '${name}' must contain only lowercase letters, numbers, and hyphens"
    else if !validLength
    then throw "Skill name '${name}' exceeds maximum length of 64 characters"
    else true;

  # Validate description length (max 1024 chars)
  validateDescription = name: desc: let
    descLength = stringLength desc;
  in
    if descLength > 1024
    then throw "Skill '${name}' description exceeds maximum length of 1024 characters (current: ${toString descLength})"
    else true;

  skillType = types.submodule ({name, ...}: {
    options = {
      description = mkOption {
        type =
          types.strMatching ".+"
          // {
            check = desc: validateDescription name desc;
          };
        description = "Brief description of what this skill does and when to use it (max 1024 characters)";
      };

      allowed-tools = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "List of tools Claude can use when this skill is active";
        example = ["Read" "Grep" "Glob" "TodoWrite"];
      };

      instructions = mkOption {
        type = types.str;
        description = "Markdown instructions for the skill";
      };

      additionalFiles = mkOption {
        type = types.attrsOf types.str;
        default = {};
        description = ''
          Additional files to create alongside SKILL.md.
          Keys are file paths relative to the skill directory, values are file contents.
        '';
        example = {
          "reference.md" = "# Reference documentation";
          "scripts/helper.sh" = "#!/usr/bin/env bash\necho 'Helper script'";
        };
      };
    };
  });
in {
  options.claude.code.skills = mkOption {
    type = types.attrsOf skillType;
    default = {};
    description = "Claude Code skills configuration";
  };

  config = mkIf (cfg.skills != {}) {
    # Validate all skill names
    assertions =
      mapAttrsToList (name: skill: {
        assertion = validateSkillName name;
        message = "Invalid skill name: ${name}";
      })
      cfg.skills;

    # Generate SKILL.md files and additional files in .claude/skills/ directory
    enterShell = mkAfter ''
      mkdir -p .claude/skills

      ${concatStringsSep "\n" (mapAttrsToList (name: skill: ''
            mkdir -p .claude/skills/${name}

            # Generate SKILL.md
            cat > .claude/skills/${name}/SKILL.md << 'SKILL_EOF'
          ---
          name: ${name}
          description: ${skill.description}
          ${optionalString (skill.allowed-tools != []) "allowed-tools: ${concatStringsSep ", " skill.allowed-tools}"}
          ---

          ${skill.instructions}
          SKILL_EOF

            # Generate additional files
            ${concatStringsSep "\n" (mapAttrsToList (filePath: content: ''
                  mkdir -p "$(dirname .claude/skills/${name}/${filePath})"
                  cat > .claude/skills/${name}/${filePath} << 'FILE_EOF'
              ${content}
              FILE_EOF
                  ${optionalString (hasSuffix ".sh" filePath || hasSuffix ".py" filePath) ''
                chmod +x .claude/skills/${name}/${filePath}
              ''}
            '')
            skill.additionalFiles)}
        '')
        cfg.skills)}
    '';
  };
}
