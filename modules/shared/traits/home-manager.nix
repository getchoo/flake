{
  config,
  lib,
  inputs,
  inputs',
  ...
}:
let
  cfg = config.traits.home-manager;
in
{
  options.traits.home-manager = {
    enable = lib.mkEnableOption "the use of home-manager";
  };

  config = lib.mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {
        inherit inputs inputs';
      };
    };
  };
}
