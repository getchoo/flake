{
  config,
  inputs',
  secretsDir,
  ...
}: {
  age.secrets.atticCreds.file = secretsDir + "/atticCreds.age";

  environment.systemPackages = [inputs'.attic.packages.default];

  services.atticd = {
    enable = true;

    credentialsFile = config.age.secrets.atticCreds.path;

    settings = {
      listen = "[::]:5000";

      api-endpoint = "https://cache.${config.networking.domain}/";

      chunking = let
        kb = 1024;
      in {
        nar-size-threshold = 64 * kb;
        min-size = 16 * kb;
        avg-size = 64 * kb;
        max-size = 256 * kb;
      };

      compression.type = "zstd";
    };
  };
}
