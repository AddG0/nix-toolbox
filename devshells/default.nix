{
  pkgs,
  inputs,
  self',
}: {
  default = import ./default {inherit pkgs inputs;};
  terraform = import ./terraform {inherit pkgs inputs self';};
  terragrunt = import ./terragrunt {inherit pkgs inputs self';};
}
