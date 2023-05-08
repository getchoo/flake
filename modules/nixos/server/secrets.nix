{
  config,
  lib,
  self,
  ...
}: let
  cfg = config.getchoo.server.secrets;
  inherit (lib) mkEnableOption mkIf;
in {
  options.getchoo.server.secrets = {
    enable = mkEnableOption "enable secret management";
  };

  config.age = let
    baseDir = "${self}/secrets/hosts/${config.networking.hostName}";
  in
    mkIf cfg.enable {
      identityPaths = ["/etc/age/key"];

      secrets = {
        rootPassword.file = "${baseDir}/rootPassword.age";
        userPassword.file = "${baseDir}/userPassword.age";
      };
    };
}
