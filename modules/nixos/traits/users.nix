{
  config,
  lib,
  secretsDir,
  ...
}: let
  cfg = config.traits.users;
in {
  options.traits.users = {
    seth = {
      manageSecrets =
        lib.mkEnableOption "automatic secrets management"
        // {
          default = config.traits.secrets.enable;
        };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.seth.enable && cfg.seth.manageSecrets) {
      age.secrets = {
        sethPassword.file = secretsDir + "/sethPassword.age";
      };

      users.users.seth = {
        hashedPasswordFile = lib.mkDefault config.age.secrets.sethPassword.path;
      };
    })
  ];
}
