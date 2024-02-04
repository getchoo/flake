{
  inputs,
  inputs',
  ...
}: {
  imports = [
    ./seth.nix
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {inherit inputs inputs';};
  };
}
