{
  pkgs,
  specialArgs,
  user,
  system ? "x86_64-linux",
  nixpkgsStable,
}: let
  common = {
    username = "seth";
    stateVersion = "23.05";
  };
in
  with user; {
    hm.seth = mkHMUser {
      inherit (common) username stateVersion;
      inherit system;
      channel = pkgs;
      extraSpecialArgs = {
        inherit nixpkgsStable;
        standalone = true;
        desktop = "";
      };
    };

    system = mkUser {
      inherit (common) username stateVersion;
      inherit system;
      extraGroups = ["wheel"];
      extraModules = [
        {
          programs.fish.enable = true;
        }
      ];
      extraSpecialArgs = specialArgs;
      hashedPassword = "***REMOVED***";
      shell = pkgs.legacyPackages.${system}.fish;
      hm = true;
    };
  }
