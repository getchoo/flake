{
  config,
  lib,
  ...
}:
let
  cfg = config.traits.arm-builder;
in
{
  options.traits.arm-builder = {
    enable = lib.mkEnableOption "ARM remote builders";
  };

  config = lib.mkIf cfg.enable {
    nix = {
      buildMachines = [
        {
          hostName = "atlas";
          maxJobs = 4;
          publicHostKey = "IyBhdGxhczoyMiBTU0gtMi4wLVRhaWxzY2FsZQphdGxhcyBzc2gtZWQyNTUxOSBBQUFBQzNOemFDMWxaREkxTlRFNUFBQUFJQzdZaVNZWXgvK3ptVk9QU0NFUkh6U3NNZVVRdEErVnQxVzBzTFV3NFloSwo=";
          sshUser = "atlas";
          supportedFeatures = [
            "benchmark"
            "big-parallel"
            "gccarch-armv8-a"
            "kvm"
            "nixos-test"
          ];
          systems = [
            "aarch64-linux"
          ];
        }
      ];

      distributedBuilds = true;

      settings = {
        builders-use-substitutes = true;
      };
    };
  };
}
