{
  terranix = {
    package =
      pkgs:
      pkgs.opentofu.withPlugins (plugins: [
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
}
