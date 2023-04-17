{lib}: rec {
  mkHost = {
    name,
    modules,
    specialArgs ? {},
    system ? "x86_64-linux",
    stateVersion ? "22.11",
    pkgs,
    inputs,
  }:
    with pkgs.lib;
      nixosSystem {
        inherit system specialArgs;
        modules =
          [
            ../modules
            ../hosts/${name}

            {
              system.stateVersion = stateVersion;
              networking.hostName = mkDefault name;

              nixpkgs = {
                overlays = with inputs; [nur.overlay getchoo.overlays.default];
                config.allowUnfree = true;
              };
              nix.registry.getchoo.flake = inputs.getchoo;

              nixos.enable = true;
            }
          ]
          ++ modules;
      };

  mapHosts = inputs: let
    hosts = import ../hosts inputs;
    inherit (lib.my) mapFilterDirs;
  in
    mapFilterDirs ../hosts (n: v: v == "directory" && n != "turret") (name: _:
      mkHost ({
          inherit name inputs;
        }
        // hosts.${name}));
}
