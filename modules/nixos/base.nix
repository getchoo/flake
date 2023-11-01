{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault;
in {
  imports = [
    ../shared
  ];

  environment.systemPackages = with pkgs; [man-pages man-pages-posix];

  documentation.man = {
    generateCaches = mkDefault true;
    man-db.enable = mkDefault true;
  };

  i18n = {
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
    ];

    defaultLocale = "en_US.UTF-8";
  };

  networking.networkmanager = {
    enable = mkDefault true;
    dns = mkDefault "systemd-resolved";
  };

  nix = {
    channel.enable = mkDefault false;
    gc.dates = mkDefault "weekly";
    settings.trusted-users = ["root" "@wheel"];
  };

  programs = {
    git.enable = mkDefault true;
    vim.defaultEditor = mkDefault true;
  };

  security = {
    apparmor.enable = mkDefault true;
    audit.enable = mkDefault true;
    auditd.enable = mkDefault true;
    polkit.enable = mkDefault true;
    rtkit.enable = mkDefault true;
    sudo.execWheelOnly = true;
  };

  services = {
    dbus.apparmor = mkDefault "enabled";

    resolved = {
      enable = mkDefault true;
      dnssec = mkDefault "allow-downgrade";
      extraConfig = mkDefault ''
        [Resolve]
        DNS=1.1.1.1 1.0.0.1
        DNSOverTLS=yes
      '';
    };

    journald.extraConfig = ''
      MaxRetentionSec=1w
    '';
  };

  system.activationScripts."upgrade-diff" = {
    supportsDryActivation = true;
    text = ''
      ${pkgs.nvd}/bin/nvd --nix-bin-dir=${config.nix.package}/bin diff /run/current-system "$systemConfig"
    '';
  };

  users = {
    defaultUserShell = pkgs.bash;
    mutableUsers = false;

    users.root = let
      # yes this is a bad way to detect which option should be used (or exists)
      # but i'm lazy. please do not copy this
      passwordFile =
        if lib.versionAtLeast config.system.stateVersion "23.11"
        then "hashedPasswordFile"
        else "passwordFile";
    in {
      home = mkDefault "/root";
      uid = mkDefault config.ids.uids.root;
      group = mkDefault "root";
      "${passwordFile}" = mkDefault config.age.secrets.rootPassword.path;
    };
  };
}
