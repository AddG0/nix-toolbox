{
  pkgs,
  inputs,
  self',
}: let
  pre-commit = inputs.git-hooks.lib.${pkgs.system}.run {
    src = ./.;
    hooks = {
      alejandra.enable = true;
      prettier.enable = true;
      shfmt.enable = true;
      tflint.enable = true;
      terraform-format.enable = true;
      terraform-validate.enable = true;
    };
  };
in
  pkgs.mkShell {
    name = "terraform-shell";

    packages = [
      pkgs.opentofu
      pkgs.terraform-docs
      pkgs.glab
      pkgs.terragrunt
      pkgs.kubectl
      self'.packages.gke-gcloud-auth-plugin
    ];
    shellHook = pre-commit.shellHook;
  }
