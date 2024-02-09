{lib, ...}: {
  mkProxy = endpoint: port: {
    "${endpoint}" = {
      proxyPass = "http://localhost:${toString port}";
      proxyWebsockets = true;
    };
  };

  toVHosts = domain:
    lib.mapAttrs' (
      name: value: lib.nameValuePair "${name}.${domain}" value
    );
}
