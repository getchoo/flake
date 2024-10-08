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
        apply-tf = {
          type = "app";
          program = lib.getExe (
            pkgs.writeShellScriptBin "apply" ''
              cp --force ${terranix} config.tf.json \
                && ${lib.getExe opentofu} init \
                && ${lib.getExe opentofu} apply
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
