{self, ...}: {
  perSystem = {
    lib,
    pkgs,
    system,
    inputs',
    self',
    ...
  }: {
    packages = {
      ciGate = let
        inherit (self.lib.ci) toTopLevel;
        isCompatible = self.lib.ci.isCompatibleWith system;

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
  };
}
