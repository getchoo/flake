{lib, ...}: {
  resource.tailscale_acl.default = {
    acl = toString (builtins.toJSON {
      tagOwners = let
        me = ["getchoo@github"];
        tags = map (name: "tag:${name}") ["server" "personal" "gha"];
      in
        lib.genAttrs tags (_: me);

      acls = let
        mkAcl = action: src: dst: {inherit action src dst;};
      in [
        (mkAcl "accept" ["tag:personal"] ["*:*"])
        (mkAcl "accept" ["tag:server" "tag:gha"] ["tag:server:*"])
      ];

      ssh = let
        mkSshAcl = action: src: dst: users: {inherit action src dst users;};
      in [
        (mkSshAcl "accept" ["tag:personal"] ["tag:server" "tag:personal"] ["autogroup:nonroot" "root"])
        (mkSshAcl "accept" ["tag:gha"] ["tag:server"] ["root"])
      ];
    });
  };
}
