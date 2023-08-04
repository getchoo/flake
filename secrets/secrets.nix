let
  main = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ5K+yLHuz4kyCkJDX2Gd/uGVNEJroIAU/h0f9E2Mapn getchoo-nix"
  ];

  atlas = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBA861lnShM2ejpzn9arzhpw33I4XdtULfZWhMp/plvL root@atlas"] ++ main;
  p-body = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAVieG9wj00Cz0Co7QYNkoTgfO+B8EO5vlZdfMvCHD76 root@p-body"] ++ main;
in {
  "shared/rootPassword.age".publicKeys = main;
  "shared/sethPassword.age".publicKeys = main;
  "shared/cloudflareApiKey.age".publicKeys = atlas ++ (builtins.filter (v: !(builtins.elem v main)) p-body);

  "hosts/atlas/rootPassword.age".publicKeys = atlas;
  "hosts/atlas/userPassword.age".publicKeys = atlas;
  "hosts/atlas/binaryCache.age".publicKeys = atlas;
  "hosts/atlas/clusterToken.age".publicKeys = atlas;
  "hosts/atlas/secretsJson.age".publicKeys = atlas;
  "hosts/atlas/miniflux.age".publicKeys = atlas;
  "hosts/atlas/tailscaleAuthKey.age".publicKeys = atlas;
  "hosts/atlas/cloudflaredCreds.age".publicKeys = atlas;

  "hosts/p-body/rootPassword.age".publicKeys = p-body;
  "hosts/p-body/userPassword.age".publicKeys = p-body;
  "hosts/p-body/p-body2atlas.age".publicKeys = p-body;
  "hosts/p-body/binaryCache.age".publicKeys = p-body;
  "hosts/p-body/clusterToken.age".publicKeys = p-body;
  "hosts/p-body/secretsJson.age".publicKeys = p-body;
  "hosts/p-body/tailscaleAuthKey.age".publicKeys = p-body;
  "hosts/p-body/cloudflaredCreds.age".publicKeys = p-body;
}
