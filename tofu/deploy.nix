{
  module.deploy_nixos = rec {
    source = "github.com/nix-community/terraform-nixos//deploy_nixos?ref=646cacb12439ca477c05315a7bfd49e9832bc4e3";

    build_on_target = "true";
    flake = true;
    hermetic = true;
    ssh_agent = false;

    nixos_config = "atlas";

    target_user = "root";
    target_host = nixos_config;
  };
}
