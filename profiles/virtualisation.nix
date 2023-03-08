{pkgs, ...}: {
  virtualisation = {
    podman = {
      enable = true;
      enableNvidia = true;
      extraPackages = with pkgs; [podman-compose];
      autoPrune.enable = true;
    };
    oci-containers.backend = "podman";
  };
}
