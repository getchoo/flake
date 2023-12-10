{secretsDir, ...}: {
  age = {
    identityPaths = ["/etc/age/key"];

    secrets = {
      rootPassword.file = secretsDir + "/rootPassword.age";
      userPassword.file = secretsDir + "/userPassword.age";
    };
  };
}
