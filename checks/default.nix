{pkgs}: {
  format = pkgs.runCommand "check-format" {} ''
    ${pkgs.alejandra}/bin/alejandra --check ${../.}
    touch $out
  '';
}
