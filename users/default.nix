{
  inputs,
  self,
  ...
}: let
  inherit (self.lib.configs) genHMModules mapHMUsers;
  inherit (inputs) arkenfox getchoo nixpkgs nix-index-database nur;

  users = let
    seth = system: {
      pkgs = import nixpkgs {
        inherit system;
        overlays = [nur.overlay getchoo.overlays.default];
      };

      modules = [
        nix-index-database.hmModules.nix-index
        arkenfox.hmModules.arkenfox
      ];
    };
  in {
    seth = seth "x86_64-linux";
  };
in {
  flake = {
    homeConfigurations = mapHMUsers users;
    homeManagerModules = genHMModules users;
  };
}
