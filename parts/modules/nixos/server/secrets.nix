{
  config,
  lib,
  self,
  ...
}: let
  cfg = config.server.secrets;
  inherit (lib) mkEnableOption mkIf;
in {
  options.server.secrets = {
    enable = mkEnableOption "enable secret management";
  };

  config.age = let
    baseDir = "${self}/parts/secrets/systems/${config.networking.hostName}";
  in
    mkIf cfg.enable {
      identityPaths = ["/etc/age/key"];

      secrets = {
        rootPassword.file = "${baseDir}/rootPassword.age";
        userPassword.file = "${baseDir}/userPassword.age";
      };
    };
}
