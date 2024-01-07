{
  config,
  inputs,
  ...
}: {
  imports = with inputs; [
    nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
    nixos-hardware.nixosModules.common-pc-ssd
  ];

  hardware.nvidia = {
    package = config.boot.kernelPackages.nvidiaPackages.production;

    modesetting.enable = true;
  };
}
