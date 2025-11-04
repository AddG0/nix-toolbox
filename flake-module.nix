# Flake module for importing nix-toolbox into other flakes
#
# Usage in your flake:
#
# {
#   inputs.nix-toolbox.url = "github:yourorg/nix-toolbox";
#
#   outputs = inputs @ {flake-parts, ...}:
#     flake-parts.lib.mkFlake {inherit inputs;} {
#       imports = [
#         inputs.nix-toolbox.flakeModules.default
#       ];
#     };
# }
{inputs, ...}: {
  imports = [
    ./lib/flake-module.nix
    ./modules/flake-module.nix
    ./overlays/flake-module.nix
    ./packages/flake-module.nix
  ];
}
