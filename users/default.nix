{inputs, ...}: {
  configurations = {
    home = {
      builder = inputs.home-manager.lib.homeManagerConfiguration;
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

      users = {
        seth = {};
      };
    };
  };
}
