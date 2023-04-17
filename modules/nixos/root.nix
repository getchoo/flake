{
  config,
  lib,
  ...
}: let
  cfg = config.nixos.defaultRoot;
  inherit (lib) mkEnableOption mkIf;
in {
  options.nixos.defaultRoot.enable = mkEnableOption "enable default root user";

  config = mkIf cfg.enable {
    users.users.root = {
      home = "/root";
      uid = config.ids.uids.root;
      group = "root";
      passwordFile = config.age.secrets.rootPassword.path;
    };
  };
}
