{lib, ...}: let
  inherit (builtins) mapAttrs;
  inherit (lib) recursiveUpdate;
in {
  mkProxy = endpoint: port: {
    "${endpoint}" = {
      proxyPass = "http://localhost:${toString port}";
      proxyWebsockets = true;
    };
  };

  mkVHosts = let
    commonSettings = {
      enableACME = true;
      # workaround for https://github.com/NixOS/nixpkgs/issues/210807
      acmeRoot = null;

      addSSL = true;
    };
  in
    mapAttrs (_: recursiveUpdate commonSettings);
}
