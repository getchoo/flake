{inputs, ...}: {
  perSystem = {
    lib,
    pkgs,
    system,
    ...
  }: let
    config = inputs.terranix.lib.terranixConfiguration {
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
    apps =
      lib.genAttrs ["apply" "destroy" "plan"] (fn: {
        type = "app";

        program = pkgs.writeShellApplication {
          name = fn;

          runtimeInputs = [pkgs.opentofu];

          text = ''
            config_file="config.tf.json"
            [ -e "$config_file" ] && rm -f "$config_file"
            cp ${config} "$config_file"
            tofu init && tofu ${fn}
          '';
        };
      })
      // {
        tofu-config = {
          type = "app";

          program = pkgs.writeShellApplication {
            name = "tofu-config";

            runtimeInputs = [pkgs.opentofu];

            text = ''
              config_file="config.tf.json"
              [ -e "$config_file" ] && rm -f "$config_file"
              cp ${config} "$config_file"
            '';
          };
        };
      };
  };
}
