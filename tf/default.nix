{inputs, ...}: {
  perSystem = {
    lib,
    pkgs,
    system,
    ...
  }: let
    tfConfig = inputs.terranix.lib.terranixConfiguration {
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
    apps.gen-tf = {
      type = "app";

      program = pkgs.writeShellApplication {
        name = "gen-tf";

        text = ''
          config_file="config.tf.json"
          [ -e "$config_file" ] && rm -f "$config_file"
          cp ${tfConfig} "$config_file"
        '';
      };
    };
  };
}
