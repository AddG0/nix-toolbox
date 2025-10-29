{
  pkgs,
  inputs,
}: let
  pre-commit = inputs.git-hooks.lib.${pkgs.system}.run {
    src = ./.;
    hooks = {
      alejandra.enable = true;
    };
  };
in
  pkgs.mkShell {
    name = "general-shell";
    shellHook = pre-commit.shellHook;
  }
