{
  config,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
  ];

  hardware.nvidia = {
    # 545 isn't stable enough yet
    # production driver as of 6a9382b8d1d9531be1a2fd611f3f91f30fb38678
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "535.146.02";
      sha256_64bit = "sha256-Sf0cyeRFyYspP3xm82vs/hLMwd6WDf/z8dyWujqcv3A=";
      sha256_aarch64 = "sha256-8G0oNdaVWxIGwVaQSw/cojy4TIAuiUBF3B98BI4hEec=";
      openSha256 = "sha256-Oyllcy3uYYK912CIusMwjKKHtMgoyOxpZWQQ8hIycuk=";
      settingsSha256 = "sha256-IrN2NaPrZSN0sCZqYNJ43iCicX3ziwUgyLLSRzp9sHQ=";
      persistencedSha256 = "sha256-trIddaTgKXszEJunK+t6D+e3HbLDTfAsitdEYRgwRNQ=";
    };

    modesetting.enable = true;
  };
}
