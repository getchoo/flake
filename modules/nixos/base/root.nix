{
  config,
  lib,
  ...
}: let
  cfg = config.getchoo.base.defaultRoot;
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  options.getchoo.base.defaultRoot.enable = mkEnableOption "enable default root user";

  config = mkIf cfg.enable {
    users.users.root = {
      home = mkDefault "/root";
      uid = mkDefault config.ids.uids.root;
      group = mkDefault "root";
      passwordFile = mkDefault config.age.secrets.rootPassword.path;
    };
  };
}