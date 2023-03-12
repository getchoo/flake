{
  inputs,
  mapFilterDirs,
}: rec {
  mkHost = {
    name,
    modules,
    specialArgs ? {},
    system ? "x86_64-linux",
    stateVersion ? "22.11",
    pkgs,
  }:
    with pkgs.lib;
      nixosSystem {
        inherit system specialArgs;
        modules =
          [
            ../profiles/base
            ../profiles/nixos
            ../hosts/${name}

            {
              system.stateVersion = stateVersion;
              networking.hostName = mkDefault name;
              nixpkgs = {
                overlays = with inputs; [nur.overlay getchoo.overlays.default];
                config = {
                  allowUnfree = true;
                  allowUnsupportedSystem = true;
                };
              };
              nix.registry.getchoo.flake = inputs.getchoo;
            }
          ]
          ++ modules;
      };

  mapHosts = hosts:
    mapFilterDirs ../hosts (_: v: v == "directory") (name: _:
      mkHost {
        inherit name;
        inherit (hosts.${name}) modules system stateVersion pkgs;
      });
}
