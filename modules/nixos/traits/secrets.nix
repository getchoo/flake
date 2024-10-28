{
  config,
  lib,
  inputs,
  secretsDir,
  ...
}:
let
  cfg = config.traits.secrets;
in
{
  options.traits.secrets = {
    enable = lib.mkEnableOption "secrets management";

    rootUser = lib.mkEnableOption "manage secrets for root user" // {
      default = true;
    };

    hostUser = lib.mkEnableOption "manager secrets for host user (see `profiles.server.hostUser`)" // {
      default = config.profiles.server.hostUser;
      defaultText = "config.profiles.server.hostUser";
    };
  };

  imports = [ inputs.agenix.nixosModules.default ];

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        _module.args = {
          secretsDir = inputs.self + "/secrets/${config.networking.hostName}";
        };

        age = {
          identityPaths = [ "/etc/age/key" ];
        };
      }

      (lib.mkIf cfg.rootUser {
        age.secrets = {
          rootPassword.file = secretsDir + "/rootPassword.age";
        };

        users.users.root = {
          hashedPasswordFile = config.age.secrets.rootPassword.path;
        };
      })

      (lib.mkIf (config.profiles.server.enable && cfg.hostUser) {
        age.secrets = {
          userPassword.file = secretsDir + "/userPassword.age";
        };

        users.users.${config.networking.hostName} = {
          hashedPasswordFile = config.age.secrets.userPassword.path;
        };
      })
    ]
  );
}
