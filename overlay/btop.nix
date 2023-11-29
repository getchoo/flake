_: prev: {
  btop =
    if prev.stdenv.isLinux
    then
      prev.symlinkJoin {
        inherit (prev.btop) passthru;
        name = "btop-nodesktop-${prev.btop.version}";
        paths = [prev.btop];
        postBuild = ''
          rm -rf $out/share/{icons,applications}
        '';
      }
    else prev.btop;
}
