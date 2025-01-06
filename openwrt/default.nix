{
  lib,
  withSystem,
  inputs,
  ...
}:

{
  flake.legacyPackages.x86_64-linux = withSystem "x86_64-linux" (
    { pkgs, ... }:

    let
      callPackage = lib.callPackageWith (pkgs // { inherit openwrtPackages; });
      openwrtPackages = {
        profileFromRelease =
          release: (inputs.openwrt-imagebuilder.lib.profiles { inherit pkgs release; }).identifyProfile;

        buildOpenWrtImage =
          { profile, ... }@args:
          inputs.openwrt-imagebuilder.lib.build (
            openwrtPackages.profileFromRelease args.release profile
            // lib.removeAttrs args [
              "profile"
              "release"
            ]
          );
      };
    in

    {
      turret = callPackage ./turret.nix { };
    }
  );
}
