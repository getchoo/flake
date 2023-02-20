{ config
, pkgs
, home-manager
, desktop
, ...
}: {
  users.users.seth = {
    extraGroups = [ "wheel" ];
    isNormalUser = true;
    hashedPassword = "***REMOVED***";
    shell = pkgs.bash;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.seth = {
      imports =
        [
          ./home.nix
          ./shell
        ]
        ++ (
          if (desktop != "")
          then [ ./desktop ]
          else [ ]
        );

      home.stateVersion = config.system.stateVersion;
      nixpkgs.config.allowUnfree = true;
      programs.home-manager.enable = true;
      systemd.user.startServices = true;
    };
  };
}
