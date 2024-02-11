{
  withSystem,
  inputs,
  ...
}: {
  flake.legacyPackages.x86_64-linux = withSystem "x86_64-linux" ({pkgs, ...}: {
    openWrtImages = {
      turret = pkgs.callPackage ./turret {
        inherit (inputs) openwrt-imagebuilder;
      };
    };
  });
}
