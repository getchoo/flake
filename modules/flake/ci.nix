{
  myLib,
  self,
  ...
}: {
  flake = {
    hydraJobs = let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    in
      with (myLib.my.ci supportedSystems); {
        apps = mkCompatibleApps self.apps;
        checks = mkCompatible self.checks;
        devShells = mkCompatible self.devShells;
        formatter = mkCompatibleFormatters self.formatter;
        homeConfigurations = mkCompatibleHM self.homeConfigurations;
        hosts = mkCompatibleCfg' self.nixosConfigurations;
        packages = mkCompatiblePkgs self.packages;
      };
  };
}
