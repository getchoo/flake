_: prev: {
  fish =
    if prev.stdenv.isLinux
    then
      prev.symlinkJoin {
        inherit (prev.fish) passthru;
        name = "fish-nodesktop";
        paths = [prev.fish];
        postBuild = ''
          rm -rf $out/share/{applications,icons}
        '';
      }
    else prev.fish;
}
