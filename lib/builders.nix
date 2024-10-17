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
      specialArgs ? { },
      ...
    }@args:
    nixpkgs.lib.nixosSystem (
      lib.removeAttrs args [ "nixpkgs" ]
      // {
        specialArgs = specialArgs // {
          inherit inputs;
        };
      }
    );

  darwinSystem =
    {
      nix-darwin ? inputs.nix-darwin or inputs.darwin,
      specialArgs ? { },
      ...
    }@args:
    nix-darwin.lib.darwinSystem (
      lib.removeAttrs args [ "nix-darwin" ]
      // {
        specialArgs = specialArgs // {
          inherit inputs;
        };
      }
    );

  homeManagerConfiguration =
    {
      extraSpecialArgs ? { },
      ...
    }@args:
    inputs.home-manager.lib.homeManagerConfiguration (
      args
      // {
        extraSpecialArgs = extraSpecialArgs // {
          inherit inputs;
        };
      }
    );

  mkModule =
    {
      name,
      type,
      imports,
    }@args:
    {
      _file = "${self.outPath}/flake.nix#${type}Modules.${name}";
      inherit imports;
    }
    // lib.removeAttrs args [
      "name"
      "type"
    ];
}
