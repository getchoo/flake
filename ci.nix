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
  in {
    checks = {
      ciGate = pkgs.runCommand "ci-gate" {
        nativeBuildInputs = lib.concatLists [
          systems
          # and other checks
          (builtins.attrValues (builtins.removeAttrs config.checks ["ciGate"]))
        ];
      } "touch $out";
    };
  };
}
