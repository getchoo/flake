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
    age = {
      identityPaths = ["/etc/age/key"];
    };
  };
}
