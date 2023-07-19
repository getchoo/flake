{pkgs, ...}: {
  programs.vim = {
    enable = true;
    packageConfigurable = pkgs.vim;
    settings = {
      expandtab = false;
      shiftwidth = 2;
      tabstop = 2;
    };
    extraConfig = ''
      " https://wiki.archlinux.org/title/XDG_Base_Directory
      set runtimepath^=$XDG_CONFIG_HOME/vim
      set runtimepath+=$XDG_DATA_HOME/vim
      set runtimepath+=$XDG_CONFIG_HOME/vim/after

      set packpath^=$XDG_DATA_HOME/vim,$XDG_CONFIG_HOME/vim
      set packpath+=$XDG_CONFIG_HOME/vim/after,$XDG_DATA_HOME/vim/after
      set packpath^=$XDG_DATA_HOME/vim,$XDG_CONFIG_HOME/vim
      set packpath+=$XDG_CONFIG_HOME/vim/after,$XDG_DATA_HOME/vim/after

      let g:netrw_home = $XDG_DATA_HOME."/vim"
      call mkdir($XDG_DATA_HOME."/vim/spell", 'p')

      set backupdir=$XDG_STATE_HOME/vim/backup | call mkdir(&backupdir, 'p')
      set directory=$XDG_STATE_HOME/vim/swap   | call mkdir(&directory, 'p')
      set undodir=$XDG_STATE_HOME/vim/undo     | call mkdir(&undodir,   'p')
      set viewdir=$XDG_STATE_HOME/vim/view     | call mkdir(&viewdir,   'p')
      set viminfofile=$XDG_STATE_HOME/vim/viminfo
    '';
  };
}
