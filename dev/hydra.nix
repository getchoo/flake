{
  lib,
  self,
  withSystem,
  ...
}:
{

  flake.hydraJobs =
    let
      # Architecture of "main" CI machine
      ciSystem = "x86_64-linux";

      derivFromCfg = deriv: deriv.config.system.build.toplevel or deriv.activationPackage;
      mapCfgsToDerivs = lib.mapAttrs (lib.const derivFromCfg);
    in
    withSystem ciSystem (
      { pkgs, self', ... }:
      {
        # I don't care to run these for each system, as they should be the same
        # and don't need to be cached
        inherit (self') checks devShells;

        darwinConfigurations = mapCfgsToDerivs self.darwinConfigurations;
        homeConfigurations = mapCfgsToDerivs self.homeConfigurations;
        nixosConfigurations = mapCfgsToDerivs self.nixosConfigurations // {
          # please add aarch64 runners github...please...
          atlas = lib.deepSeq (derivFromCfg self.nixosConfigurations.atlas).drvPath pkgs.emptyFile;
        };
      }
    );
}
