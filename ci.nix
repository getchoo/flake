{self, ...}: {
  perSystem = {
    lib,
    pkgs,
    system,
    config,
    ...
  }: {
    packages = let
      allConfigurations = [
        "nixosConfigurations"
        "darwinConfigurations"
        "homeConfigurations"
      ];

      configurations = lib.pipe allConfigurations [
        (configs: lib.getAttrs configs self)
        builtins.attrValues
        (lib.concatMap builtins.attrValues)
        (lib.filter (deriv: deriv.pkgs.system == system))
        (map (deriv: deriv.config.system.build.toplevel or deriv.activationPackage))
      ];

      required = [
        configurations
        (builtins.attrValues config.checks)
        (builtins.attrValues config.devShells)
      ];
    in {
      ciGate = pkgs.writeText "ci-gate" ''
        ${lib.concatMapStringsSep "\n" toString required}
      '';
    };
  };
}
