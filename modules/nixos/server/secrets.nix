{config, ...}: {
  age = let
    baseDir = ../../../secrets/systems/${config.networking.hostName};
  in {
    identityPaths = ["/etc/age/key"];

    secrets = {
      rootPassword.file = "${baseDir}/rootPassword.age";
      userPassword.file = "${baseDir}/userPassword.age";
    };
  };
}
