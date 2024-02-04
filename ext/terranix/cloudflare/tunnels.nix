{lib, ...}: {
  data.cloudflare_tunnel =
    lib.genAttrs
    [
      "atlas-nginx"
    ]
    (name: {
      inherit name;
      account_id = lib.tfRef "var.account_id";
    });
}
