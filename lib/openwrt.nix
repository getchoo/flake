{
  lib,
  inputs,
  ...
}: {
  profileFromRelease = pkgs: release:
    (inputs.openwrt-imagebuilder.lib.profiles {
      inherit pkgs release;
    })
    .identifyProfile;

  mkImage = pkgs: {profile, ...} @ args:
    inputs.openwrt-imagebuilder.lib.build (
      lib.profileFromRelease pkgs args.release profile
      // builtins.removeAttrs args ["profile" "release"]
    );

  mapImagesWith = pkgs: lib.mapAttrs (lib.const (lib.mkImage pkgs));
}
