{
  perSystem = {pkgs, ...}: {
    terranix = {
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
