{ config
, pkgs
, ...
}: {
  users = {
    defaultUserShell = pkgs.bash;
    mutableUsers = false;

    users = {
      root = {
        home = "/root";
        uid = config.ids.uids.root;
        group = "root";
        initialHashedPassword = "***REMOVED***";
      };
    };
  };
}
