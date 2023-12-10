{
  config,
  secretsDir,
  ...
}: {
  age.secrets = {
    cloudflareApiKey.file = secretsDir + "/cloudflareApiKey.age";
  };

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "getchoo@tuta.io";
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets.cloudflareApiKey.path;
    };
  };
}
