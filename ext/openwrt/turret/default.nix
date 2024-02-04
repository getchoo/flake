{
  pkgs,
  openwrt-imagebuilder,
  ...
}: let
  wrtProfiles = openwrt-imagebuilder.lib.profiles {
    inherit pkgs;
    release = "22.03.3";
  };

  image =
    wrtProfiles.identifyProfile "netgear_wac104"
    // {
      packages = ["https-dns-proxy"];

      files = pkgs.runCommand "image-files" {} ''
        mkdir -p $out/etc/uci-defaults

        cat > $out/etc/uci-defaults/99-custom <<EOF
        uci -q batch << EOI
        set system.@system[0].hostname='turret'
        commit
        EOI
        EOF

        # copy custom files
        cp -fr ${./files}/* $out/
        chmod 0644 $out/etc/{config,dropbear}/*
      '';
    };
in
  openwrt-imagebuilder.lib.build image
