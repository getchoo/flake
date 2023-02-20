{ home-manager, ... }: {
  mkHost =
    { name
    , modules
    , system ? "x86_64-linux"
    , specialArgs ? { }
    , version ? "22.11"
    , pkgs
    ,
    }: {
      ${name} = with pkgs.lib;
        nixosSystem {
          inherit system specialArgs;
          modules =
            [
              ../hosts/common
              ../hosts/${name}

              ({ pkgs, ... }: {
                system.stateVersion = version;
                networking.hostName = mkDefault name;
                # enable non-free packages
                nixpkgs.config.allowUnfree = true;

                # Enable nix flakes
                nix = {
                  package = pkgs.nixFlakes;
                  settings.experimental-features = [ "nix-command" "flakes" ];
                };
              })

              home-manager.nixosModules.home-manager
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  extraSpecialArgs = specialArgs;
                };
              }
            ]
            ++ modules;
        };
    };
}
