{
  lib,
  inputs,
  self,
}:
let
  /**
    Wrap the `args` applied to `builder` with the result of `apply`

    # Type

    ```
    wrapBuilderWith :: (AttrSet -> AttrSet) -> (AttrSet -> AttrSet) -> AttrSet -> AttrSet
    ```
  */
  wrapBuilderWith =
    apply: builder: args:
    builder (apply args);

  /**
    Wrap the `args` applied to `builder` with the result of `apply`

    # Type

    ```
    wrapBuilder :: String -> (AttrSet -> AttrSet) -> AttrSet -> AttrSet
    ```
  */
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

  /**
    Wrap the `args` to the NixOS `builder` function with nice defaults

    # Type

    ```
    wrapNixOS :: (AttrSet -> AttrSet) -> AttrSet -> AttrSet
    ```
  */
  wrapNixOS = builder: args: wrapBuilder "nixos" builder args;

  /**
    Wrap the `args` to the nix-darwin `builder` function with nice defaults

    # Type

    ```
    wrapDarwin :: (AttrSet -> AttrSet) -> AttrSet -> AttrSet
    ```
  */
  wrapDarwin = builder: args: wrapBuilder "darwin" builder args;

  /**
    Wrap the `args` to the home-manager `builder` function with nice defaults

    # Type

    ```
    wrapUser :: (AttrSet -> AttrSet) -> AttrSet -> AttrSet
    ```
  */
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

  /**
    Wrap the `args` to `nixpkgs.lib.nixosSystem` function with nice defaults

    # Example

    ```
    nixosSystem { module = [ ./configuration.nix ]; }
    ```

    # Type

    ```
    nixosSystem :: AttrSet -> AttrSet
    ```

    # Arguments

    - [args] Base arguments to `nixpkgs.lib.nixosSystem`
  */
  nixosSystem = wrapNixOS inputs.nixpkgs.lib.nixosSystem;

  /**
    Wrap the `args` to `nixpkgs-stable.lib.nixosSystem` with nice defaults

    # Example

    ```
    nixosSystemStable { module = [ ./configuration.nix ]; }
    ```

    # Type

    ```
    nixosSystemStable :: AttrSet -> AttrSet
    ```

    # Arguments

    - [args] Base arguments to `nixpkgs.lib.nixosSystem`
  */
  nixosSystemStable = wrapNixOS inputs.nixpkgs-stable.lib.nixosSystem;

  /**
    Wrap the `args` to `nix-darwin.lib.darwinSystem` with nice defaults

    # Example

    ```
    darwinSystem { module = [ ./configuration.nix ]; }
    ```

    # Type

    ```
    darwinSystem :: AttrSet -> AttrSet
    ```

    # Arguments

    - [args] Base arguments to `nix-darwin.lib.darwinSystem`
  */
  darwinSystem = wrapDarwin inputs.nix-darwin.lib.darwinSystem;

  /**
    Wrap the `args` to `home-manager.lib.homeManagerConfiguration` with nice defaults

    # Example

    ```
    homeManagerConfiguration { module = [ ./configuration.nix ]; }
    ```

    # Type

    ```
    homeManagerConfiguration :: AttrSet -> AttrSet
    ```

    # Arguments

    - [args] Base arguments to `home-manager.lib.homeManagerConfiguration`
  */
  homeManagerConfiguration = wrapUser inputs.home-manager.lib.homeManagerConfiguration;
}
