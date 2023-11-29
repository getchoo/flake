_: prev: {
  vim-full =
    if prev.stdenv.isLinux
    then
      prev.vimUtils.makeCustomizable (
        prev.symlinkJoin {
          inherit (prev.vim-full) passthru;
          name = "vim-nodesktop-${prev.vim-full.version}";
          paths = [prev.vim-full];
          postBuild = ''
            rm -rf $out/share/{icons,applications}
          '';
        }
      )
    else prev.vim-full;
}
