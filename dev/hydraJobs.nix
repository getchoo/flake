{
  lib,
  self,
  withSystem,
  ...
}:
let
  # architecture of "main" CI machine
  ciSystem = "x86_64-linux";

  /**
    Map a NixOS, nix-darwin, or home-manager configuration to a final derivation

    # Type

    ```
    derivFromCfg :: AttrSet -> Attrset
    ```
  */
  derivFromCfg = deriv: deriv.config.system.build.toplevel or deriv.activationPackage;

  /**
    Map an attribute set of NixOS, nix-darwin, or home-manager configurations to their final derivation

    # Type

    ```
    mapCfgsToDerivs :: AttrSet -> Attrset
    ```
  */
  mapCfgsToDerivs = lib.mapAttrs (lib.const derivFromCfg);
in
{
  flake.hydraJobs = withSystem ciSystem (
    { pkgs, self', ... }:
    {
      # i don't care to run these for each system, as they should be the same
      # and don't need to be cached
      inherit (self') checks;
      inherit (self') devShells;

      darwinConfigurations = mapCfgsToDerivs self.darwinConfigurations;
      homeConfigurations = mapCfgsToDerivs self.homeConfigurations;
      nixosConfigurations = mapCfgsToDerivs self.nixosConfigurations // {
        # please add aarch64 runners github...please...
        atlas = lib.deepSeq (derivFromCfg self.nixosConfigurations.atlas).drvPath pkgs.emptyFile;
      };
    }
  );
}
