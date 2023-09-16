{
  config,
  lib,
  ...
}: let
  cfg = config.base.defaultRoot;
  inherit (lib) mkDefault mkEnableOption mkIf;

  # yes this is a bad way to detect which option should be used (or exists)
  # but i'm lazy. please do not copy this
  passwordFile =
    if lib.versionAtLeast config.system.stateVersion "23.11"
    then "hashedPasswordFile"
    else "passwordFile";
in {
  options.base.defaultRoot.enable = mkEnableOption "default root user";

  config = mkIf cfg.enable {
    users.users.root = {
      home = mkDefault "/root";
      uid = mkDefault config.ids.uids.root;
      group = mkDefault "root";
      "${passwordFile}" = mkDefault config.age.secrets.rootPassword.path;
    };
  };
}
