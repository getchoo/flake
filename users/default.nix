{inputs}:
with inputs; {
  users = {system}: {
    seth = {
      pkgs = nixpkgsUnstable.legacyPackages.${system};
      stateVersion = "23.05";
    };
  };
}
