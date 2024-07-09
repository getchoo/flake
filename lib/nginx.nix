lib: {
  /**
    Create an NGINX virtualHost submodule proxying a local port

    # Example

    ```nix
    mkProxy "/" "3000"
    => {
      proxyPass = "http://localhost:3000";
      proxyWebsockets = true;
    }
    ```

    # Type

    ```
    mkProxy :: String -> Number -> AttrSet
    ```

    # Arguments

    - [endpoint] virtualHost endpoint that `port` will be proxied towards
    - [port] Port to be proxied
  */
  mkProxy = endpoint: port: {
    "${endpoint}" = {
      proxyPass = "http://localhost:${toString port}";
      proxyWebsockets = true;
    };
  };

  /**
    Transform the names of an attribute set of nginx virtualHosts into a full subdomain

    # Example

    ```nix
    toVHosts "example.com" {
      subdomain = { };
    }
    => {
    	"subdomain.example.com" = { };
    }
    ```

    # Type

    ```
    toVHosts :: String -> AttrSet -> AttrSet
    ```

    # Arguments

    - [domain] Root domain used
    - [subdomainMap] A name value pair of subdomains and their virtualHost options
  */
  toVHosts = domain: lib.mapAttrs' (name: lib.nameValuePair "${name}.${domain}");
}
