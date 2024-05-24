{
  config,
  lib,
  inputs,
  ...
}: let
  cfg = config.traits.home-manager;
in {
  options.traits.home-manager = {
    enable = lib.mkEnableOption "home-manager configuration";
  };

  config = lib.mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = {inherit inputs;};
    };
  };
}
