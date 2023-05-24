{
  config,
  self,
  ...
}: let
  inherit (config.networking) hostName;
in {
  age.secrets = {
    "${hostName}2atlas" = {
      file = "${self}/secrets/hosts/${hostName}/${hostName}2atlas.age";
      mode = "600";
      owner = config.users.users.hydra-queue-runner.name;
      inherit (config.users.users.hydra-queue-runner) group;
    };
  };

  nix = {
    buildMachines = [
      {
        hostName = "localhost";
        speedFactor = 75;
        supportedFeatures = ["big-parallel" "benchmark" "kvm" "nixos-test"];
        system = "x86_64-linux";
      }
      {
        hostName = "atlas";
        maxJobs = 4;
        speedFactor = 100;
        sshUser = "bob";
        sshKey = config.age.secrets."${hostName}2atlas".path;
        supportedFeatures = ["benchmark" "big-parallel" "gccarch-armv8-a" "kvm" "nixos-test"];
        systems = ["aarch64-linux" "x86_64-linux"];
      }
    ];

    distributedBuilds = true;
    settings.builders-use-substitutes = true;
  };
}
