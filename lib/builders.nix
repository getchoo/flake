{
  lib,
  inputs,
  self,
  ...
}:
{
  nixosSystem =
    {
      nixpkgs ? inputs.nixpkgs,
      modules ? [ ],
      specialArgs ? { },
      ...
    }@args:
    nixpkgs.lib.nixosSystem (
      lib.removeAttrs args [ "nixpkgs" ]
      // {
        modules = modules ++ lib.attrValues (self.nixosModules or [ ]);
        specialArgs = specialArgs // {
          inherit inputs;
        };
      }
    );

  darwinSystem =
    {
      nix-darwin ? inputs.nix-darwin or inputs.darwin,
      modules ? [ ],
      specialArgs ? { },
      ...
    }@args:
    nix-darwin.lib.darwinSystem (
      lib.removeAttrs args [ "nix-darwin" ]
      // {
        modules = modules ++ lib.attrValues (self.darwinModules or { });
        specialArgs = specialArgs // {
          inherit inputs;
        };
      }
    );

  homeManagerConfiguration =
    {
      modules ? [ ],
      extraSpecialArgs ? { },
      ...
    }@args:
    inputs.home-manager.lib.homeManagerConfiguration (
      args
      // {
        modules = modules ++ lib.attrValues (self.homeModules or self.homeManagerModules or { });
        extraSpecialArgs = extraSpecialArgs // {
          inherit inputs;
        };
      }
    );

}
