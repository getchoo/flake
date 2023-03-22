{
  pkgs,
  openwrt-imagebuilder,
  ...
}: let
  inherit (pkgs) runCommand;
  inherit (pkgs.stdenv) mkDerivation;
  inherit (openwrt-imagebuilder.lib) build profiles;
  wrtProfiles = profiles {
    inherit pkgs;
    release = "22.03.3";
  };
  config = mkDerivation {
    name = "openwrt-config-files";
    src = ./files;
    installPhase = ''
      mkdir -p $out
      cp -r * $out/
    '';
  };
  image =
    wrtProfiles.identifyProfile "netgear_wac104"
    // {
      packages = ["https-dns-proxy"];

      files = runCommand "image-files" {} ''
        mkdir -p $out/etc/uci-defaults
        cat > $out/etc/uci-defaults/99-custom <<EOF
        uci -q batch << EOI
        set system.@system[0].hostname='turret'
        commit
        EOI
        EOF
        cp -fr ${config}/etc/* $out/etc/
      '';
    };
in
  build image
