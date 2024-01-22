let
  toSecrets = import ./toSecrets.nix;

  owners = {
    getchoo = "age1zyqu6zkvl0rmlejhm5auzmtflfy4pa0fzwm0nzy737fqrymr7crsqrvnhs";
  };

  hosts = {
    glados = {
      owner = owners.getchoo;
      pubkey = "age1n7tyxx63wpgnmwkzn7dmkm62jxel840rk3ye3vsultrszsfrwuzsawdzhq";
      files = [
        "rootPassword.age"
        "sethPassword.age"
      ];
    };

    glados-wsl = {
      pubkey = "age1ffqfq3azqfwxwtxnfuzzs0y566a7ydgxce4sqxjqzw8yexc2v4yqfr55vr";
      owner = owners.getchoo;
      inherit (hosts.glados) files;
    };

    atlas = {
      pubkey = "age18eu3ya4ucd2yzdrpkpg7wrymrxewt8j3zj2p2rqgcjeruacp0dgqryp39z";
      owner = owners.getchoo;
      files = [
        "rootPassword.age"
        "userPassword.age"
        "miniflux.age"
        "tailscaleAuthKey.age"
        "cloudflaredCreds.age"
        "teawieBot.age"
      ];
    };
  };
in
  toSecrets hosts
