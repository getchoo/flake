{
  lib,
  self,
  ...
}: {
  flake.hydraJobs = let
    ciSystems = ["x86_64-linux"];
    ci = self.lib.ci ciSystems;
  in
    builtins.foldl' lib.recursiveUpdate {} [
      (
        lib.genAttrs
        ["nixosConfigurations" "homeConfigurations"]
        (
          type: ci.mapCfgsToDerivs (ci.getCompatibleCfgs self."${type}")
        )
      )
      (
        lib.genAttrs
        ["checks" "devShells"]
        (type: ci.getOutputs self.${type})
      )
    ];
}
