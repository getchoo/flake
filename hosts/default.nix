{inputs}:
with inputs; let
  common = {
    system = "x86_64-linux";
    stateVersion = "23.05";
    pkgs = nixpkgsUnstable;
    modules = with inputs; [
      agenix.nixosModules.default
      home-manager.nixosModules.home-manager
      nur.nixosModules.nur
      {
        age = {
          identityPaths = ["/etc/age/key"];
          secrets = {
            rootPassword.file = ../users/secrets/rootPassword.age;
            sethPassword.file = ../users/secrets/sethPassword.age;
          };
        };
      }
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
