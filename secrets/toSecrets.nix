hosts:
let
  optional = attrset: val: if attrset ? ${val} then [ attrset.${val} ] else [ ];

  mkPubkeys = host: optional host "pubkey" ++ optional host "owner";

  op =
    acc: host:
    acc
    // (builtins.listToAttrs (
      map (file: {
        name = "${host}/${file}";
        value = {
          publicKeys = mkPubkeys hosts.${host};
        };
      }) hosts.${host}.files
    ));
in
builtins.foldl' op { } (builtins.attrNames hosts)
