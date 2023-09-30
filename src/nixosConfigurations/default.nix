{
  inputs,
  root,
  ...
}: {
  atlas = with root.profiles.server;
    builder {
      system = "aarch64-linux";
      inherit specialArgs;
      modules =
        modules
        ++ [
          ./_atlas/configuration.nix
          inputs.guzzle_api.nixosModules.default
        ];
    };

  glados = with root.profiles.personal;
    builder {
      inherit system specialArgs;
      modules =
        modules
        ++ [
          ./_glados/configuration.nix
          inputs.lanzaboote.nixosModules.lanzaboote
        ];
    };

  glados-wsl = with root.profiles.personal;
    builder {
      inherit system specialArgs;
      modules =
        modules
        ++ [
          ./_glados-wsl/configuration.nix
          inputs.nixos-wsl.nixosModules.wsl
        ];
    };
}
