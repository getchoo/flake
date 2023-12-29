{
  lib,
  self,
  ...
}: {
  flake.hydraJobs = let
    ciSystems = ["x86_64-linux"];
    getOutputs = lib.getAttrs ciSystems;
  in
    lib.attrsets.mergeAttrsList [
      {
        checks = getOutputs self.checks;
        devShells = getOutputs self.devShells;
        homeConfigurations = lib.mapAttrs (_: v:
          lib.mapAttrs (_: v: v.activationPackage) v.homeConfigurations)
        (getOutputs self.legacyPackages);
      }

      (
        let
          toDerivs = lib.mapAttrs (_: configuration: configuration.config.system.build.toplevel);
          toCompatible = lib.filterAttrs (_: configuration: lib.elem configuration.pkgs.system ciSystems);
          getConfigurationsFor = type: toDerivs (toCompatible self.${type});
        in {
          nixosConfigurations = getConfigurationsFor "nixosConfigurations";
        }
      )
    ];
}
