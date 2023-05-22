{config, ...}: let
  inherit (config.networking) hostName;
in {
  nix = {
    buildMachines = [
      {
        hostName = "localhost";
        speedFactor = -1;
        supportedFeatures = ["big-parallel" "benchmark" "kvm" "nixos-test"];
        system = "x86_64-linux";
      }
      {
        hostName = "atlas";
        maxJobs = 4;
        speedFactor = 2;
        sshUser = "bob";
        sshKey = config.age.secrets."${hostName}2atlas".path;
        supportedFeatures = ["benchmark" "big-parallel" "gccarch-armv8-a" "kvm" "nixos-test"];
        system = "aarch64-linux";
      }
    ];

    distributedBuilds = true;
    settings.builders-use-substitutes = true;
  };
}
