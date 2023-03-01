{home-manager, ...}: let
  commonHM = {
    nixpkgs.config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };
    xdg.configFile."nixpkgs/config.nix".text = ''
      {
        allowUnfree = true;
      }
    '';
  };
in {
  mkHMUser = {
    username,
    channel,
    modules ? [],
    stateVersion ? "22.11",
    system ? "x86_64-linux",
    extraSpecialArgs ? {},
  }:
    home-manager.lib.homeManagerConfiguration {
      pkgs = channel.legacyPackages.${system};
      inherit extraSpecialArgs;
      modules =
        [
          ../users/${username}/home.nix
          ({pkgs, ...}:
            {
              home = {
                inherit username stateVersion;
                homeDirectory = "/home/${username}";
              };

              programs.home-manager.enable = true;
              nix = {
                package = pkgs.nixFlakes;
                settings.experimental-features = ["nix-command" "flakes"];
              };
            }
            // commonHM)
        ]
        ++ modules;
    };
  mkUser = {
    username,
    extraGroups ? [],
    extraModules ? [],
    extraSpecialArgs ? {},
    hashedPassword,
    hm ? false,
    shell,
    stateVersion,
    system ? "x86_64-linux",
  }:
    [
      {
        users.users.${username} = {
          inherit extraGroups hashedPassword shell;
          isNormalUser = true;
        };
      }
    ]
    ++ extraModules
    ++ (
      if hm
      then [
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            inherit extraSpecialArgs;
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username} =
              {
                imports = [
                  ../users/${username}/home.nix
                ];
                home.stateVersion = stateVersion;
              }
              // commonHM
              // (
                if builtins.match ".*-linux" system != null
                then {systemd.user.startServices = true;}
                else {}
              );
          };
        }
      ]
      else []
    );
}
