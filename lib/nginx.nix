lib: {
  # string -> int -> { }
  # create an nginx virtualHost submodule proxying local port
  # `port` to `endpoint`
  mkProxy = endpoint: port: {
    "${endpoint}" = {
      proxyPass = "http://localhost:${toString port}";
      proxyWebsockets = true;
    };
  };

  # string -> { } -> { }
  # transform the names of an attribute set of nginx virtualHosts
  # into a full subdomain
  toVHosts = domain: lib.mapAttrs' (name: lib.nameValuePair "${name}.${domain}");
}
