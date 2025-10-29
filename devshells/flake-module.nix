{inputs, ...}: {
  perSystem = {
    pkgs,
    self',
    ...
  }: {
    devShells = import ./. {inherit pkgs inputs self';};
  };
}
