{
  lib,
  self,
  ...
}: {
  nix2workflow.output = self.hydraJobs;

  flake.hydraJobs = let
    ciSystems = ["x86_64-linux" "x86_64-darwin"];
    recursiveMerge = builtins.foldl' lib.recursiveUpdate {};
  in
    recursiveMerge [
      (let
        outputs = lib.getAttrs ["checks" "devShells"] self;
        isCompatible = system: _: lib.elem system ciSystems;
      in
        lib.mapAttrs (_: lib.filterAttrs isCompatible) outputs)

      (
        let
          configurations =
            lib.getAttrs [
              "nixosConfigurations"
              "darwinConfigurations"
              "homeConfigurations"
            ]
            self;

          isCompatible = _: configuration: lib.elem configuration.pkgs.system ciSystems;
          toDeriv = _: configuration: configuration.config.system.build.toplevel or configuration.activationPackage;
        in
          lib.mapAttrs (_: v: lib.mapAttrs toDeriv (lib.filterAttrs isCompatible v)) configurations
      )
    ];
}
