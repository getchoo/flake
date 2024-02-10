{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.traits.secrets;
in {
  options.traits.secrets = {
    enable = lib.mkEnableOption "secrets management";
  };

  imports = [inputs.agenix.nixosModules.default];

  config = lib.mkIf cfg.enable {
    _module.args = {
      secretsDir = ../../../secrets/${config.networking.hostName};
    };

    age = {
      identityPaths = ["/etc/age/key"];
    };
  };
}
