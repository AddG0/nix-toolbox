{pkgs}: {
  gke-gcloud-auth-plugin = import ./gke-gcloud-auth-plugin {inherit pkgs;};
  mcp-google-sheets = pkgs.callPackage ./mcp-google-sheets/package.nix {};
}
