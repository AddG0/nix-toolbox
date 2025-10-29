{...}: {
  flake.devenvModules = {
    claude-code-skills = ./claude-code-skills.nix;
    vscode = ./vscode.nix;
  };
}
