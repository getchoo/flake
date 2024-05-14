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

  resource.cloudflare_authenticated_origin_pulls = {
    getchoo_com_origin = {
      zone_id = lib.tfRef "var.getchoo_com_zone_id";
      enabled = true;
    };
  };
}
