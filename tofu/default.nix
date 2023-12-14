{inputs, ...}: {
  perSystem = {
    lib,
    pkgs,
    system,
    ...
  }: let
    tofuConfig = inputs.terranix.lib.terranixConfiguration {
      inherit system;
      modules = [
        ./cloudflare
        ./tailscale
        ./cloud.nix
        ./vars.nix
        ./versions.nix
      ];
    };
  in {
    apps.gen-tofu = {
      type = "app";

      program = pkgs.writeShellApplication {
        name = "tofu-config";

        runtimeInputs = [pkgs.opentofu];

        text = ''
          config_file="config.tf.json"
          [ -e "$config_file" ] && rm -f "$config_file"
          cp ${tofuConfig} "$config_file"
        '';
      };
    };
  };
}
