{
  config,
  secretsDir,
  ...
}: {
  age.secrets.atticCreds.file = secretsDir + "/atticCreds.age";

  services.atticd = {
    enable = true;
    credentialsFile = config.age.secrets.atticCreds.path;

    settings = {
      listen = "[::]:5000";
      api-endpoint = "https://cache.${config.networking.domain}/";

      compression.type = "zstd";

      chunking = let
        kb = 1024;
      in {
        nar-size-threshold = 64 * kb;
        min-size = 16 * kb;
        avg-size = 64 * kb;
        max-size = 256 * kb;
      };

      storage = {
        type = "s3";
        region = "us-west-4";
        bucket = "getchoo-attic";
        endpoint = "https://s3.us-west-004.backblazeb2.com";
      };
    };
  };
}
