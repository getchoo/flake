{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    terranix = {
      builder = inputs.terranix.lib.terranixConfiguration;

      package = pkgs.opentofu.withPlugins (plugins: [
        plugins.cloudflare
        plugins.tailscale
      ]);

      modules = [
        ./cloudflare
        ./tailscale
        ./cloud.nix
        ./vars.nix
        ./versions.nix
      ];
    };
  };
}
