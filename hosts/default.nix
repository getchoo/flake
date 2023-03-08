{inputs}:
with inputs; let
  common = {
    system = "x86_64-linux";
    stateVersion = "23.05";
    pkgs = nixpkgsUnstable;
    modules = with inputs; [
      home-manager.nixosModules.home-manager
      nur.nixosModules.nur
    ];
  };
in {
  glados = {
    modules =
      common.modules
      ++ [
        nixos-hardware.nixosModules.common-cpu-amd-pstate
        nixos-hardware.nixosModules.common-gpu-nvidia-nonprime
        nixos-hardware.nixosModules.common-pc-ssd
        lanzaboote.nixosModules.lanzaboote
      ];
    inherit (common) system stateVersion pkgs;
  };
  glados-wsl = {
    modules =
      common.modules
      ++ [
        nixos-wsl.nixosModules.wsl
      ];
    inherit (common) system stateVersion pkgs;
  };
}
