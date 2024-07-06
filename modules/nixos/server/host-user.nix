{
  config,
  lib,
  secretsDir,
  ...
}:
let
  cfg = config.server.hostUser;
  inherit (config.networking) hostName;
in
{
  options.server.hostUser = {
    enable = lib.mkEnableOption "${hostName} user configuration" // {
      default = config.server.enable;
    };

    manageSecrets = lib.mkEnableOption "automatic management of secrets" // {
      default = config.traits.secrets.enable;
      defaultText = lib.literalExpression "config.traits.secrets.enable";
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        users.users.${hostName} = {
          isNormalUser = true;
          extraGroups = [ "wheel" ];
        };
      }

      (lib.mkIf cfg.manageSecrets {
        age.secrets = {
          userPassword.file = secretsDir + "/userPassword.age";
        };

        users.users.${hostName} = {
          hashedPasswordFile = config.age.secrets.userPassword.path;
        };
      })
    ]
  );
}
