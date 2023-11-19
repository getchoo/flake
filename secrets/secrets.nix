let
  toSecrets = import ./toSecrets.nix;

  owners = {
    getchoo = "age1zyqu6zkvl0rmlejhm5auzmtflfy4pa0fzwm0nzy737fqrymr7crsqrvnhs";
  };

  hosts = {
    glados = {
      owner = owners.getchoo;
      files = [
        "rootPassword.age"
        "sethPassword.age"
      ];
    };

    glados-wsl = {
      pubkey = "age16jps7cr3jtjjusf3p3yadcmnmmh2kzfyfcfpv2zs6hrmnlthhf2sr05jdn";
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
        "cloudflareApiKey.age"
        "teawieBot.age"
      ];
    };
  };
in
  toSecrets hosts
