{
  config,
  pkgs,
  ...
}: {
  programs.ssh = {
    enable = true;
    package = pkgs.openssh;

    matchBlocks = let
      sshDir = "${config.home.homeDirectory}/.ssh";
    in {
      # git forges
      "github.com" = {
        identityFile = "${sshDir}/github";
        user = "git";
      };

      "codeberg.org" = {
        identityFile = "${sshDir}/codeberg";
        user = "git";
      };

      # linux packaging
      "aur.archlinux.org" = {
        identityFile = "${sshDir}/aur";
        user = "aur";
      };

      "pagure.io" = {
        identityFile = "${sshDir}/copr";
        user = "git";
      };

      # router
      "192.168.1.1" = {
        identityFile = "${sshDir}/openwrt";
        user = "root";
      };

      # servers
      "atlas".user = "atlas";
      "p-body".user = "p-body";
    };
  };

  services.ssh-agent.enable = pkgs.stdenv.isLinux;
}
