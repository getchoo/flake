{config, ...}: let
  kb = 1024;
in {
  age.secrets.atticCreds.file =
    ../../secrets/${config.networking.hostName}/atticCreds.age;

  services.atticd = {
    enable = true;
    credentialsFile = config.age.secrets.atticCreds.path;

    settings = {
      listen = "[::]:5000";
      api-endpoint = "https://cache.${config.networking.domain}/";

      compression.type = "zstd";

      chunking = {
        nar-size-threshold = 64 * kb;
        min-size = 16 * kb;
        avg-size = 64 * kb;
        max-size = 256 * kb;
      };

      database = {
        type = "s3";
        region = "us-west-004";
        bucket = "getchoo-attic";
        endpoint = "s3.us-west-004.backblazeb2.com";
      };

      garbage-collection.interval = "12 hours";
    };
  };
}
