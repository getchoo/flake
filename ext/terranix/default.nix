{ inputs, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    {
      packages = {
        opentofu = pkgs.opentofu.withPlugins (plugins: [
          plugins.cloudflare
          plugins.tailscale
        ]);

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
      };
    };
}
