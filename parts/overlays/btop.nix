_: prev: {
  btop = prev.symlinkJoin {
    inherit (prev.btop) passthru;
    name = "btop-nodesktop";
    paths = [prev.btop];
    postBuild = ''
      rm $out/share/applications/btop.desktop
    '';
  };
}
