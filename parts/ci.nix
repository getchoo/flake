{
  lib,
  self,
  withSystem,
  ...
}: let
  ciSystem = "x86_64-linux";
  derivFromCfg = deriv: deriv.config.system.build.toplevel or deriv.activationPackage;
  mapCfgsToDerivs = lib.mapAttrs (lib.const derivFromCfg);
in {
  flake.hydraJobs = withSystem ciSystem ({
    pkgs,
    self',
    ...
  }: {
    inherit (self') checks;
    inherit (self') devShells;
    darwinConfigurations = mapCfgsToDerivs self.darwinConfigurations;
    homeConfigurations = mapCfgsToDerivs self.homeConfigurations;
    nixosConfigurations =
      mapCfgsToDerivs self.nixosConfigurations
      // {
        # please add aarch64 runners github...please...
        atlas = lib.deepSeq (derivFromCfg self.nixosConfigurations.atlas).drvPath pkgs.emptyFile;
      };
  });
}
