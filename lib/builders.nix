{
  lib,
  inputs,
  self,
}:
let
  # function -> function -> { } -> { }
  # wrap the `args` applied to `builder` with the result of `apply`
  # applied to those `args`
  wrapBuilderWith =
    apply: builder: args:
    builder (apply args);

  # string -> function -> { } -> { }
  # wrap the `args` for `builder` of type `type` with nice defaults
  wrapBuilder =
    type:
    wrapBuilderWith (
      {
        modules ? [ ],
        specialArgs ? { },
        ...
      }@args:
      args
      // {
        modules = modules ++ lib.attrValues (self."${type}Modules" or { });

        specialArgs = specialArgs // {
          inherit inputs;
        };
      }
    );

  # function -> { } -> { }
  # wrap the `args` to the nixos `builder` function with nice defaults
  wrapNixOS = builder: args: wrapBuilder "nixos" builder args;
  # function -> { } -> { }
  # wrap the `args` to the darwin `builder` function with nice defaults
  wrapDarwin = builder: args: wrapBuilder "darwin" builder args;

  # function -> { } -> { }
  # wrap the `args` to the homeManager `builder` function with nice defaults
  wrapUser =
    builder: args:
    wrapBuilderWith (
      {
        modules ? [ ],
        extraSpecialArgs ? { },
        ...
      }@args:
      args
      // {
        modules = modules ++ lib.attrValues (self.homeManagerModules or { });

        extraSpecialArgs = extraSpecialArgs // {
          inherit inputs;
        };
      }
    ) builder args;
in
{

  # { } -> { }
  # apply nice defaults to the `args` of `nixosSystem`
  nixosSystem = wrapNixOS inputs.nixpkgs.lib.nixosSystem;
  # { } -> { }
  # apply nice defaults to the `args` of (stable) `nixosSystem`
  nixosSystemStable = wrapNixOS inputs.nixpkgs-stable.lib.nixosSystem;
  # { } -> { }
  # apply nice defaults to the `args` of `darwinSystem`
  darwinSystem = wrapDarwin inputs.nix-darwin.lib.darwinSystem;
  # { } -> { }
  # apply nice defaults to the `args` of `homeManagerConfiguration`
  homeManagerConfiguration = wrapUser inputs.home-manager.lib.homeManagerConfiguration;
}
