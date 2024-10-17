{
  lib,
  inputs,
  withSystem,
  ...
}:
let
  system = "x86_64-linux";
in
{
  flake.legacyPackages.${system} =
    let
      pkgs = withSystem system ({ pkgs, ... }: pkgs);

      openwrtTools = lib.makeScope pkgs.newScope (final: {
        profileFromRelease =
          release: (inputs.openwrt-imagebuilder.lib.profiles { inherit pkgs release; }).identifyProfile;

        buildOpenWrtImage =
          { profile, ... }@args:
          inputs.openwrt-imagebuilder.lib.build (
            final.profileFromRelease args.release profile
            // lib.removeAttrs args [
              "profile"
              "release"
            ]
          );
      });
    in
    {
      turret = openwrtTools.callPackage ./turret.nix { };
    };

}
