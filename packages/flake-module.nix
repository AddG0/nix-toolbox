{...}: {
  perSystem = {pkgs, ...}: {
    packages = import ./. {inherit pkgs;};
  };
}
