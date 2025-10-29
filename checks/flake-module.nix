{...}: {
  perSystem = {pkgs, ...}: {
    checks = import ./. {inherit pkgs;};
  };
}
