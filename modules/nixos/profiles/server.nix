{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.profiles.server;
in
{
  options.profiles.server = {
    enable = lib.mkEnableOption "the Server profile";

    hostUser = lib.mkEnableOption "a default interactive user" // {
      default = true;
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        # All servers are most likely on stable, so we want to pull in some newer packages from time to time
        _module.args.unstable = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};

        boot.tmp.cleanOnBoot = lib.mkDefault true;

        # We don't need it here
        documentation.enable = false;

        environment.defaultPackages = lib.mkForce [ ];

        mixins = {
          cloudflared.enable = true;
          nginx.enable = true;
        };

        nix.gc = {
          # Every ~2 days
          dates = "Mon,Wed,Fri *-*-* 00:00:00";
          options = "-d --delete-older-than 2d";
        };

        traits = {
          autoUpgrade.enable = true;
          secrets.enable = true;
          tailscale = {
            enable = true;
            ssh.enable = true;
          };
          zram.enable = true;
        };
      }

      (lib.mkIf cfg.hostUser {
        # Hardening access to `nix` as no other users *should* ever really touch it
        nix.settings.allowed-users = [ config.networking.hostName ];

        users.users.${config.networking.hostName} = {
          isNormalUser = true;
          extraGroups = [ "wheel" ];
        };
      })
    ]
  );
}
