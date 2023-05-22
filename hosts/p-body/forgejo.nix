{
  config,
  lib,
  pkgs,
  nixpkgs,
  ...
}: let
  theme = pkgs.fetchzip {
    url = "https://github.com/catppuccin/gitea/releases/download/v0.2.1/catppuccin-gitea.tar.gz";
    sha256 = "sha256-HqVLW58lKPn81p3gTSjzkACHSBbmqPqeobAlJMubb8Y=";
    stripRoot = false;
  };
in {
  users.users.forgejo = {
    useDefaultShell = true;
    home = "/var/lib/gitea";
    group = "gitea";
    isSystemUser = true;
  };

  services.gitea = let
    domain = "git.${config.networking.domain}";
  in {
    enable = true;
    package = (import nixpkgs {inherit (pkgs) system;}).forgejo;
    inherit domain;
    rootUrl = "https://${domain}/";
    appName = "forgejo: with daddy issues";
    httpAddress = "127.0.0.1";
    user = "forgejo";
    database.user = "forgejo";
    settings = {
      indexer.REPO_INDEXER_ENABLED = true;
      session = {
        COOKIE_SECURE = true;
        PROVIDER = "db";
        SAME_SITE = "strict";
      };

      service.DISABLE_REGISTRATION = true;

      server = {
        BUILTIN_SSH_USER = "forgejo";
        ENABLE_GZIP = true;
        SSH_AUTHORIZED_KEYS_BACKUP = false;
        SSH_DOMAIN = domain;
      };

      ui = {
        THEMES =
          builtins.concatStringsSep
          ","
          (["auto"]
            ++ (map (name: lib.removePrefix "theme-" (lib.removeSuffix ".css" name))
              (builtins.attrNames (builtins.readDir theme))));
        DEFAULT_THEME = "catppuccin-mocha-pink";
      };
    };
  };

  systemd.services.gitea = {
    preStart = lib.mkAfter ''
      rm -rf ${config.services.gitea.stateDir}/custom/public
      mkdir -p ${config.services.gitea.stateDir}/custom/public
      ln -sf ${theme} ${config.services.gitea.stateDir}/custom/public/css
    '';
  };
}
