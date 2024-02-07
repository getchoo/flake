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
    package = config.boot.kernelPackages.nvidiaPackages.production;
    modesetting.enable = true;
  };
}
