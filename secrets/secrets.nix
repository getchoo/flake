let
  main = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ5K+yLHuz4kyCkJDX2Gd/uGVNEJroIAU/h0f9E2Mapn getchoo-nix"
  ];

  atlas = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBA861lnShM2ejpzn9arzhpw33I4XdtULfZWhMp/plvL root@atlas"];
  p-body = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAVieG9wj00Cz0Co7QYNkoTgfO+B8EO5vlZdfMvCHD76 root@p-body"];
  keys = main ++ atlas ++ p-body;
in {
  "shared/rootPassword.age".publicKeys = main;
  "shared/sethPassword.age".publicKeys = main;

  "hosts/atlas/rootPassword.age".publicKeys = keys;
  "hosts/atlas/userPassword.age".publicKeys = keys;
  "hosts/atlas/binaryCache.age".publicKeys = keys;
  "hosts/atlas/clusterToken.age".publicKeys = keys;
  "hosts/atlas/secretsJson.age".publicKeys = keys;
  "hosts/atlas/miniflux.age".publicKeys = keys;

  "hosts/p-body/rootPassword.age".publicKeys = keys;
  "hosts/p-body/userPassword.age".publicKeys = keys;
  "hosts/p-body/binaryCache.age".publicKeys = keys;
  "hosts/p-body/clusterToken.age".publicKeys = keys;
  "hosts/p-body/secretsJson.age".publicKeys = keys;
}
