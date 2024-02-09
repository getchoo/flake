{
  config,
  lib,
  pkgs,
  secretsDir,
  ...
}: let
  cfg = config.traits.user-setup;
in {
  options.traits.user-setup = {
    enable = lib.mkEnableOption "basic immutable user & root configurations";
    manageSecrets =
      lib.mkEnableOption "automatic secrets management"
      // {
        default = config.traits.secrets.enable;
      };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        users = {
          defaultUserShell = pkgs.bash;
          mutableUsers = false;

          users.root =
            {
              home = lib.mkDefault "/root";
              uid = lib.mkDefault config.ids.uids.root;
              group = lib.mkDefault "root";
            }
            // lib.optionalAttrs cfg.manageSecrets {
              hashedPasswordFile = config.age.secrets.rootPassword.path;
            };
        };
      }

      (lib.mkIf cfg.manageSecrets {
        age.secrets = {
          rootPassword.file = secretsDir + "/rootPassword.age";
        };
      })
    ]
  );
}
