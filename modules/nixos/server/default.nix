{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  cfg = config.server;
in
{
  options.server = {
    enable = lib.mkEnableOption "basic server settings";
  };

  imports = [
    ./host-user.nix
    ./mixins
  ];

  config = lib.mkIf cfg.enable {
    # all servers are most likely on stable, so we may want to pull some newer packages from time to time
    _module.args.unstable = inputs.nixpkgs.legacyPackages.${pkgs.stdenv.hostPlatform.system};

    boot.tmp.cleanOnBoot = lib.mkDefault true;

    # we don't need it here
    documentation.enable = false;

    environment.defaultPackages = lib.mkForce [ ];

    nix = {
      gc = {
        # ~every 2 days
        dates = "Mon,Wed,Fri *-*-* 00:00:00";
        options = "-d --delete-older-than 2d";
      };

      # hardening access to `nix` on servers as no other users
      # *should* ever really touch it
      settings.allowed-users = [ config.networking.hostName ];
    };
  };
}
