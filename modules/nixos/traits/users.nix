{
  config,
  lib,
  pkgs,
  secretsDir,
  ...
}: let
  cfg = config.traits.users;
  inherit (config.networking) hostName;
in {
  options.traits.users = {
    hostUser = {
      enable = lib.mkEnableOption "${hostName} user configuration";
      manageSecrets =
        lib.mkEnableOption "automatic secrets management"
        // {
          default = config.traits.secrets.enable;
        };
    };

    seth = {
      manageSecrets =
        lib.mkEnableOption "automatic secrets management"
        // {
          default = config.traits.secrets.enable;
        };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.hostUser.enable {
      users.users.${hostName} = {
        isNormalUser = true;
        shell = pkgs.bash;
      };
    })

    (lib.mkIf (cfg.hostUser.enable && cfg.hostUser.manageSecrets) {
      age.secrets = {
        userPassword.file = secretsDir + "/userPassword.age";
      };

      users.users.${hostName} = {
        hashedPasswordFile = config.age.secrets.userPassword.path;
      };
    })

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
