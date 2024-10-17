{ inputs, ... }:
{
  perSystem =
    {
      lib,
      pkgs,
      system,
      ...
    }:
    let
      opentofu = pkgs.opentofu.withPlugins (plugins: [
        plugins.cloudflare
        plugins.tailscale
      ]);

      terranix = inputs.terranix.lib.terranixConfiguration {
        inherit system;
        modules = [ ./config.nix ];
      };
    in
    {
      apps.tf = {
        type = "app";
        program = lib.getExe (
          pkgs.writeShellScriptBin "tf" ''
            ln -sf ${terranix} config.tf.json
            exec ${lib.getExe opentofu} "$@"
          ''
        );
      };
    };
}
