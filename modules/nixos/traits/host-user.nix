{
  config,
  lib,
  pkgs,
  secretsDir,
  ...
}: let
  cfg = config.traits.users.hostUser;
  inherit (config.networking) hostName;
in {
  options.traits.users.hostUser = {
    enable = lib.mkEnableOption "${hostName} user configuration";
    manageSecrets =
      lib.mkEnableOption "automatic secrets management"
      // {
        default = config.traits.secrets.enable;
      };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        users.users.${hostName} = {
          isNormalUser = true;
          shell = pkgs.bash;
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
