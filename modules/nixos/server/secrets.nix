{
  config,
  lib,
  secretsDir,
  ...
}: let
  cfg = config.server.secrets;
in {
  options.server.secrets.enable = lib.mkEnableOption "secrets management";

  config = lib.mkIf cfg.enable {
    age = {
      identityPaths = ["/etc/age/key"];

      secrets = {
        rootPassword.file = secretsDir + "/rootPassword.age";
        userPassword.file = secretsDir + "/userPassword.age";
      };
    };
  };
}
