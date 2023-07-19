_: prev: {
  neovim = prev.symlinkJoin {
    inherit (prev.neovim) passthru;
    name = "neovim-nodesktop";
    paths = [prev.neovim];
    postBuild = ''
      rm $out/share/applications/*.desktop
    '';
  };
}
