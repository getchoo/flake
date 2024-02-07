{
  config,
  lib,
  ...
}: let
  cfg = config.traits.secrets;
in {
  options.traits.secrets = {
    enable = lib.mkEnableOption "secrets management";
  };

  config = lib.mkIf cfg.enable {
    age = {
      identityPaths = ["/etc/age/key"];
    };
  };
}
