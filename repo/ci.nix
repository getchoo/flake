{
  lib,
  self,
  ...
}: {
  flake.hydraJobs = let
    ciSystems = ["x86_64-linux"];

    getOutputs = lib.getAttrs ciSystems;

    mapCfgsToDerivs = lib.mapAttrs (_: cfg: cfg.activationPackage or cfg.config.system.build.toplevel);
    getCompatibleCfgs = lib.filterAttrs (_: cfg: lib.elem cfg.pkgs.system ciSystems);
  in
    builtins.foldl' lib.recursiveUpdate {} [
      (
        lib.genAttrs
        ["nixosConfigurations" "homeConfigurations"]
        (
          type: mapCfgsToDerivs (getCompatibleCfgs self."${type}")
        )
      )
      (
        lib.genAttrs
        ["checks" "devShells"]
        (type: getOutputs self.${type})
      )
    ];
}
