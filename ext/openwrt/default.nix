{
  withSystem,
  inputs,
  ...
}: {
  flake.legacyPackages.x86_64-linux = withSystem "x86_64-linux" ({pkgs, ...}: {
    openWrtImages = {
      turret = pkgs.callPackage ./systems/turret {
        inherit (inputs) openwrt-imagebuilder;
      };
    };
  });
}
