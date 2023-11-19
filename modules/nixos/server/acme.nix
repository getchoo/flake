{config, ...}: {
  age.secrets = {
    cloudflareApiKey.file = ../../../secrets/${config.networking.hostName}/cloudflareApiKey.age;
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
