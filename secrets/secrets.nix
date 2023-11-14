let
  main = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ5K+yLHuz4kyCkJDX2Gd/uGVNEJroIAU/h0f9E2Mapn getchoo-nix"
  ];

  atlas = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBA861lnShM2ejpzn9arzhpw33I4XdtULfZWhMp/plvL root@atlas"] ++ main;
in {
  "shared/rootPassword.age".publicKeys = main;
  "shared/sethPassword.age".publicKeys = main;

  "systems/atlas/rootPassword.age".publicKeys = atlas;
  "systems/atlas/userPassword.age".publicKeys = atlas;
  "systems/atlas/miniflux.age".publicKeys = atlas;
  "systems/atlas/tailscaleAuthKey.age".publicKeys = atlas;
  "systems/atlas/cloudflaredCreds.age".publicKeys = atlas;
  "systems/atlas/cloudflareApiKey.age".publicKeys = atlas;
  "systems/atlas/teawieBot.age".publicKeys = atlas;
}
