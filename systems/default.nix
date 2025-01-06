{ inputs, ... }:

{
  configurations = {
    nixos = {
      glados = {
        modules = [ ./glados ];
      };

      glados-wsl = {
        modules = [ ./glados-wsl ];
      };

      atlas = {
        modules = [ ./atlas ];
        nixpkgs = inputs.nixpkgs-stable;
      };
    };

    darwin = {
      caroline = {
        modules = [ ./caroline ];
      };
    };
  };
}
