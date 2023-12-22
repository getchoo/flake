{
  config,
  secretsDir,
  ...
}: {
  age.secrets.teawiebot.file = secretsDir + "/teawieBot.age";

  services.teawiebot = {
    enable = true;
    environmentFile = config.age.secrets.teawiebot.path;
  };
}
