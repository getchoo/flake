{
  config,
  lib,
  secretsDir,
  ...
}: let
  cfg = config.traits.users.seth;
  enable = cfg.enable && cfg.manageSecrets;
in {
  options.traits.users.seth = {
    manageSecrets =
      lib.mkEnableOption "automatic management of sercrets"
      // {
        default = config.traits.secrets.enable or false;
      };
  };

  imports = [./system.nix];

  config = lib.mkIf enable {
    age.secrets = {
      sethPassword.file = secretsDir + "/sethPassword.age";
    };

    users.users.seth = {
      hashedPasswordFile = lib.mkDefault config.age.secrets.sethPassword.path;
    };
  };
}
