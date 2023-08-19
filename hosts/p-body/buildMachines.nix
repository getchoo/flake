_: {
  nix = {
    buildMachines = [
      {
        hostName = "atlas";
        maxJobs = 4;
        sshUser = "bob";
        supportedFeatures = ["benchmark" "big-parallel" "gccarch-armv8-a" "kvm" "nixos-test"];
        systems = ["aarch64-linux"];
      }
    ];

    settings.builders-use-substitutes = true;
  };
}
