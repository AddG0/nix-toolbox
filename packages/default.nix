{pkgs}: {
  gke-gcloud-auth-plugin = import ./gke-gcloud-auth-plugin {inherit pkgs;};
}
