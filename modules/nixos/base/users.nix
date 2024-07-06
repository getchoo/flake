{
  config,
  lib,
  pkgs,
  secretsDir,
  ...
}:
let
  cfg = config.base.users;
in
{
  options.base.users = {
    enable = lib.mkEnableOption "basic user configurations" // {
      default = true;
    };

    defaultRoot = {
      enable = lib.mkEnableOption "default root user configuration" // {
        default = false;
      };

      manageSecrets = lib.mkEnableOption "automatic management of secrets" // {
        default = config.traits.secrets.enable;
        defaultText = lib.literalExpression "config.traits.secrets.enable";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        users = {
          defaultUserShell = pkgs.bash;
          mutableUsers = false;
        };
      }

      (lib.mkIf cfg.defaultRoot.enable {
        users.users.root = {
          home = lib.mkDefault "/root";
          uid = lib.mkDefault config.ids.uids.root;
          group = lib.mkDefault "root";
        };
      })

      (lib.mkIf (cfg.defaultRoot.enable && cfg.defaultRoot.manageSecrets) {
        age.secrets = {
          rootPassword.file = secretsDir + "/rootPassword.age";
        };

        users.users.root = {
          hashedPasswordFile = config.age.secrets.rootPassword.path;
        };
      })
    ]
  );
}
