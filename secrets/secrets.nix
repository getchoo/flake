let
  main = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ5K+yLHuz4kyCkJDX2Gd/uGVNEJroIAU/h0f9E2Mapn getchoo-nix"
  ];

  atlas = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBA861lnShM2ejpzn9arzhpw33I4XdtULfZWhMp/plvL root@atlas"] ++ main;
  p-body = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAVieG9wj00Cz0Co7QYNkoTgfO+B8EO5vlZdfMvCHD76 root@p-body"] ++ main;
in {
  "shared/rootPassword.age".publicKeys = main;
  "shared/sethPassword.age".publicKeys = main;

  "hosts/atlas/rootPassword.age".publicKeys = atlas;
  "hosts/atlas/userPassword.age".publicKeys = atlas;
  "hosts/atlas/miniflux.age".publicKeys = atlas;

  "hosts/p-body/rootPassword.age".publicKeys = p-body;
  "hosts/p-body/userPassword.age".publicKeys = p-body;
  "hosts/p-body/p-body2atlas.age".publicKeys = p-body;
  "hosts/p-body/hydraGH.age".publicKeys = p-body;
}
