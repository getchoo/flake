{
  getchoo,
  nixpkgs,
  nix-index-database,
  nur,
  ...
}: system: {
  seth = {
    pkgs = import nixpkgs {
      inherit system;
      overlays = [nur.overlay getchoo.overlays.default];
    };

    modules = [
      nix-index-database.hmModules.nix-index
    ];
  };
}
