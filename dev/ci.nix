{self, ...}: {
  perSystem = {
    lib,
    system,
    self',
    ...
  }: let
    mapSystemConfigs = type:
      lib.filterAttrs (_: v: v.system == system) (
        lib.mapAttrs' (n: v: lib.nameValuePair "${type}-${n}" v.config.system.build.toplevel) self.${type}
      );

    devShells = lib.mapAttrs' (n: lib.nameValuePair "devShell-${n}") self'.devShells;

    homeConfigurations =
      lib.mapAttrs'
      (n: v: lib.nameValuePair "homeConfiguration-${n}" v.activationPackage)
      self'.legacyPackages.homeConfigurations;

    nixosConfigurations = mapSystemConfigs "nixosConfigurations";
    darwinConfigurations = mapSystemConfigs "darwinConfigurations";
  in {
    checks = lib.attrsets.mergeAttrsList [
      devShells
      homeConfigurations
      nixosConfigurations
      darwinConfigurations
    ];
  };
}
