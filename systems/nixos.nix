{ inputs, ... }:
{
  nixosConfigurations = {
    glados = {
      modules = [ ./glados ];
    };

    glados-wsl = {
      modules = [ ./glados-wsl ];
    };

    atlas = {
      nixpkgs = inputs.nixpkgs-stable;
      modules = [ ./atlas ];
    };
  };
}
