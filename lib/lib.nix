{
  lib,
  self,
  inputs,
  ...
}: let
  wrapBuilderWith = apply: builder: args: builder (apply args);

  wrapBuilder = type:
    wrapBuilderWith ({
        modules ? [],
        specialArgs ? {},
        ...
      } @ args:
        args
        // {
          modules =
            modules
            ++ lib.attrValues (self."${type}Modules" or {});

          specialArgs = specialArgs // {inherit inputs;};
        });

  wrapNixOS = wrapBuilder "nixos";
  wrapDarwin = wrapBuilder "darwin";

  wrapUser = wrapBuilderWith ({
      modules ? [],
      extraSpecialArgs ? {},
      ...
    } @ args:
      args
      // {
        modules =
          modules
          ++ lib.attrValues (self.homeManagerModules or {});

        extraSpecialArgs = extraSpecialArgs // {inherit inputs;};
      });
in {
  nixosSystem = wrapNixOS inputs.nixpkgs.lib.nixosSystem;
  nixosSystemStable = wrapNixOS inputs.nixpkgs-stable.lib.nixosSystem;
  darwinSystem = wrapDarwin inputs.nix-darwin.lib.darwinSystem;
  homeManagerConfiguration = wrapUser inputs.home-manager.lib.homeManagerConfiguration;

  nginx = import ./nginx.nix lib;
}
