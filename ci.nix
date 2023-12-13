{self, ...}: {
  perSystem = {
    lib,
    pkgs,
    system,
    config,
    ...
  }: let
    # get applicable system configurations
    configurations = lib.getAttrs ["darwinConfigurations" "homeConfigurations" "nixosConfigurations"] self;

    systems = lib.pipe (builtins.attrValues configurations) [
      (builtins.foldl' (acc: attr: acc // attr) {})
      (lib.filterAttrs (_: v: v.pkgs.system == system))
      (lib.mapAttrsToList (_: v: v.config.system.build.toplevel or v.activationPackage))
    ];

    required = lib.concatLists [
      systems
      # and other checks
      (builtins.attrValues (builtins.removeAttrs config.checks ["ciGate"]))
    ];

    paths =
      builtins.foldl' (
        acc: deriv:
          acc // {${deriv.pname or deriv.name} = deriv.path or deriv.outPath;}
      ) {}
      required;
  in {
    packages.ciGate = pkgs.linkFarm "ci-gate" paths;
  };
}
