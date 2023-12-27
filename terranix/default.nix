{inputs, ...}: {
  perSystem = {
    lib,
    pkgs,
    system,
    self',
    opentofu',
    ...
  }: let
    terranixConfig = inputs.terranix.lib.terranixConfiguration {
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
    _module.args.opentofu' = pkgs.opentofu.withPlugins (plugins:
      with plugins; [
        cloudflare
        tailscale
      ]);

    apps.gen-terranix = {
      type = "app";

      program = pkgs.writeShellApplication {
        name = "gen-tf";

        text = ''
          config_file="config.tf.json"
          [ -e "$config_file" ] && rm -f "$config_file"
          cp ${terranixConfig} "$config_file"
        '';
      };
    };

    devShells.terranix = pkgs.mkShell {
      shellHook = ''
        ${self'.apps.gen-terranix.program}
      '';

      packages = [pkgs.just opentofu'];
    };
  };
}
