{
  config,
  secretsDir,
  ...
}: {
  age.secrets .miniflux.file = secretsDir + "/miniflux.age";

  services.miniflux = {
    enable = true;
    adminCredentialsFile = config.age.secrets.miniflux.path;
    config = {
      BASE_URL = "https://miniflux.${config.networking.domain}";
      LISTEN_ADDR = "localhost:7000";
    };
  };
}
