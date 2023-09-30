{
  hm,
  nixpkgs,
  inputs,
  ...
}: {
  seth = hm.lib.homeManagerConfiguration {
    pkgs = import nixpkgs {
      system = "x86_64-linux";
      overlays = with inputs; [nur.overlay getchoo.overlays.default];
    };

    modules = [
      ./_seth/home.nix
      {
        _module.args.osConfig = {};
        programs.home-manager.enable = true;
      }
    ];

    extraSpecialArgs = inputs // {inherit inputs;};
  };
}
