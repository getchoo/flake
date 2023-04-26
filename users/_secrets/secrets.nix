let
  keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ5K+yLHuz4kyCkJDX2Gd/uGVNEJroIAU/h0f9E2Mapn getchoo-nix"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAVieG9wj00Cz0Co7QYNkoTgfO+B8EO5vlZdfMvCHD76 root@p-body"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBA861lnShM2ejpzn9arzhpw33I4XdtULfZWhMp/plvL root@atlas"
  ];
in {
  "rootPassword.age".publicKeys = keys;
  "sethPassword.age".publicKeys = keys;
  "pbodyPassword.age".publicKeys = keys;
  "atlasPassword.age".publicKeys = keys;
}
