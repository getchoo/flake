{config, ...}: {
  users.users.root = {
    home = "/root";
    uid = config.ids.uids.root;
    group = "root";
    passwordFile = config.age.secrets.rootPassword.path;
  };
}
