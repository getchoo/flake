let
  key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ5K+yLHuz4kyCkJDX2Gd/uGVNEJroIAU/h0f9E2Mapn getchoo-nix";
in {
  "rootPassword.age".publicKeys = [key];
  "sethPassword.age".publicKeys = [key];
}
