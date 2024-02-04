{
  config,
  lib,
  secretsDir,
  ...
}: let
  cfg = config.suites.personal;
in {
  config = lib.mkIf cfg.enable {
    age = {
      identityPaths = ["/etc/age/key"];
      secrets = {
        rootPassword.file = secretsDir + "/rootPassword.age";
        sethPassword.file = secretsDir + "/sethPassword.age";
      };
    };
  };
}
