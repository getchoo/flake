{inputs, ...}: {
  configurations = {
    home = {
      builder = inputs.hm.lib.homeManagerConfiguration;
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;

      users = {
        seth = {};
      };
    };
  };
}
