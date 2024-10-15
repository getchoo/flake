{ inputs, ... }:
{
  perSystem =
    {
      lib,
      pkgs,
      self',
      system,
      ...
    }:
    let
      inherit (self'.packages) opentofu;

      terranix = inputs.terranix.lib.terranixConfiguration {
        inherit system;
        modules = [
          ./cloudflare
          ./tailscale
          ./cloud.nix
          ./vars.nix
          ./versions.nix
        ];
      };
    in
    {
      apps = {
        tf = {
          type = "app";
          program = lib.getExe (
            pkgs.writeShellScriptBin "tf" ''
              ln -sf ${terranix} config.tf.json
              exec ${lib.getExe opentofu} "$@"
            ''
          );
        };
      };

      packages.opentofu = pkgs.opentofu.withPlugins (plugins: [
        plugins.cloudflare
        plugins.tailscale
      ]);
    };
}
