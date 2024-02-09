{self, ...}: {
  perSystem = {
    lib,
    pkgs,
    system,
    self',
    ...
  }: let
    ci = self.lib.ci [system];

    configurations = map (type: ci.mapCfgsToDerivs (ci.getCompatibleCfgs self.${type})) [
      "nixosConfigurations"
      "darwinConfigurations"
      "homeConfigurations"
    ];

    required = lib.concatMap lib.attrValues (
      [
        self'.checks
        self'.devShells
      ]
      ++ configurations
    );
  in {
    packages.ciGate = pkgs.writeText "ci-gate" (
      lib.concatMapStringsSep "\n" toString required
    );
  };
}
