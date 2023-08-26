{
  inputs,
  self,
  ...
}: let
  inherit (self.lib.configs) genHMModules mapHMUsers;
  inherit (inputs) getchoo nixpkgs nix-index-database nur;

  users = let
    seth = system: {
      pkgs = import nixpkgs {
        inherit system;
        overlays = [nur.overlay getchoo.overlays.default];
      };

      modules = [
        nix-index-database.hmModules.nix-index
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
