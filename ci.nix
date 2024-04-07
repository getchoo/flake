{self, ...}: {
  perSystem = {
    lib,
    pkgs,
    system,
    self',
    ...
  }: {
    packages.ciGate = let
      toTopLevel = cfg: cfg.config.system.build.toplevel or cfg.activationPackage;
      isCompatible = cfg: cfg.pkgs.system == system;

      configurations =
        map
        (type:
          lib.mapAttrs (lib.const toTopLevel)
          (lib.filterAttrs (lib.const isCompatible) self.${type}))
        [
          "nixosConfigurations"
          "darwinConfigurations"
          "homeConfigurations"
        ];

      required = lib.concatMap lib.attrValues (
        lib.flatten [self'.checks self'.devShells configurations]
      );
    in
      pkgs.writeText "ci-gate" (
        lib.concatMapStringsSep "\n" toString required
      );
  };
}
