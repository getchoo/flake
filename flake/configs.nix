{
  inputs,
  self,
  ...
}: let
  inherit (inputs) nixinate openwrt-imagebuilder;
  inherit ((inputs.getchoo.lib inputs).configs) mapHMUsers mapHosts;
in {
  flake = {
    nixosConfigurations = mapHosts ../hosts;

    nixosModules.getchoo = import ../modules;
  };

  perSystem = {
    pkgs,
    system,
    ...
  }: {
    apps = (nixinate.nixinate.${system} self).nixinate;

    legacyPackages.homeConfigurations = mapHMUsers system ../users;

    packages = {
      turret = pkgs.callPackage ../hosts/_turret {inherit openwrt-imagebuilder;};
    };
  };
}
