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
    };
  };

  nix = {
    buildMachines = [
      {
        hostName = "atlas";
        maxJobs = 4;
        sshUser = "bob";
        sshKey = config.age.secrets."${hostName}2atlas".path;
        supportedFeatures = ["benchmark" "big-parallel" "gccarch-armv8-a" "kvm" "nixos-test"];
        systems = ["aarch64-linux" "x86_64-linux" "i686-linux"];
      }
    ];

    settings.builders-use-substitutes = true;
  };
}
