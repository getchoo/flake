{config, ...}: let
  baseDir = ../../../secrets/${config.networking.hostName};
in {
  age = {
    identityPaths = ["/etc/age/key"];

    secrets = {
      rootPassword.file = "${baseDir}/rootPassword.age";
      userPassword.file = "${baseDir}/userPassword.age";
    };
  };
}
