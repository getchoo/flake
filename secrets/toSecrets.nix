hosts:
let
  # Find any public keys from a given system's attributes
  findPubkeysIn =
    host:
    builtins.filter (item: item != null) [
      (host.pubkey or null)
      (host.owner or null)
    ];

  # Memorize them for later
  publicKeysFor = builtins.mapAttrs (_: findPubkeysIn) hosts;

  # Map secret files meant for `hostname` to an attribute set containing
  # their relative path and public keys
  #
  # See https://github.com/ryantm/agenix/blob/de96bd907d5fbc3b14fc33ad37d1b9a3cb15edc6/README.md#tutorial
  # as a reference to what this outputs
  secretsFrom =
    hostname: host:
    builtins.listToAttrs (
      map (file: {
        name = "${hostname}/${file}";
        value = {
          publicKeys = publicKeysFor.${hostname};
        };

      }) host.files
    );

  # Memorize them all
  secretsFor = builtins.mapAttrs secretsFrom hosts;
in
# Now merge them all into one attribute set
builtins.foldl' (acc: secrets: acc // secrets) { } (builtins.attrValues secretsFor)
