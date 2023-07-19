_: prev: {
  fish = prev.symlinkJoin {
    inherit (prev.fish) passthru;
    name = "fish-nodesktop";
    paths = [prev.fish];
    postBuild = ''
      rm $out/share/applications/fish.desktop
    '';
  };
}
