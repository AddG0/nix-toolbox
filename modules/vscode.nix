{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.vscode;
in {
  options.vscode = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable VSCode workspace configuration";
    };

    launch = mkOption {
      type = types.attrs;
      default = {};
      description = "Configuration for .vscode/launch.json (will be converted to JSON)";
      example = literalExpression ''
        {
          version = "0.2.0";
          configurations = [
            {
              type = "node";
              request = "launch";
              name = "Launch Program";
              program = "''${workspaceFolder}/index.js";
            }
          ];
        }
      '';
    };

    settings = mkOption {
      type = types.attrs;
      default = {};
      description = "Configuration for .vscode/settings.json (will be converted to JSON)";
      example = literalExpression ''
        {
          "editor.formatOnSave" = true;
          "editor.tabSize" = 2;
          "files.exclude" = {
            "**/.git" = true;
            "**/.DS_Store" = true;
          };
        }
      '';
    };
  };

  config = mkIf cfg.enable (let
    # Generate JSON files in the nix store
    launchJson = pkgs.writers.writeJSON "launch.json" cfg.launch;
    settingsJson = pkgs.writers.writeJSON "settings.json" cfg.settings;
  in {
    # Generate .vscode directory and symlink configuration files
    enterShell = mkAfter ''
      mkdir -p .vscode

      ${optionalString (cfg.launch != {}) ''
        # Symlink launch.json
        ln -sf ${launchJson} .vscode/launch.json
      ''}

      ${optionalString (cfg.settings != {}) ''
        # Symlink settings.json
        ln -sf ${settingsJson} .vscode/settings.json
      ''}
    '';
  });
}
