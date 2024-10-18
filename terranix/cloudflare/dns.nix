{ lib, ... }:
let
  mkRecord =
    {
      name,
      content,
      type,
      zone_id,
    }:
    {
      inherit
        name
        content
        type
        zone_id
        ;
      ttl = 1;
    }
    // lib.optionalAttrs (type != "TXT") { proxied = true; };

  zones = {
    getchoo_com = lib.tfRef "var.getchoo_com_zone_id";
  };
  inherit (zones) getchoo_com;

  atlas_tunnel =
    lib.tfRef "data.cloudflare_zero_trust_tunnel_cloudflared.atlas-nginx.id" + ".cfargotunnel.com";

  pagesSubdomainFor = project: lib.tfRef "resource.cloudflare_pages_project.${project}.subdomain";
  blockEmailSpoofingFor =
    domain:
    let
      zone_id = zones.${domain};
    in
    {
      "${domain}_dmarc" = {
        name = "_dmarc";
        content = "v=DMARC1; p=reject; sp=reject; adkim=s; aspf=s;";
        type = "TXT";
        inherit zone_id;
      };

      "${domain}_domainkey" = {
        name = "*._domainkey";
        content = "v=DKIM1; p=";
        type = "TXT";
        inherit zone_id;
      };

      "${domain}_email" = {
        name = "@";
        content = "v=spf1 -all";
        type = "TXT";
        inherit zone_id;
      };
    };
in
{
  resource.cloudflare_zone_dnssec = {
    getchoo_com_dnssec = {
      zone_id = getchoo_com;
    };
  };

  resource.cloudflare_record =
    lib.mapAttrs (_: mkRecord) {
      getchoo_com_website = {
        name = "@";
        content = pagesSubdomainFor "personal_website";
        type = "CNAME";
        zone_id = getchoo_com;
      };

      getchoo_com_www = {
        name = "www";
        content = "getchoo.com";
        type = "CNAME";
        zone_id = getchoo_com;
      };

      getchoo_com_api = {
        name = "api";
        content = pagesSubdomainFor "teawie_api";
        type = "CNAME";
        zone_id = getchoo_com;
      };

      getchoo_com_miniflux = {
        name = "miniflux";
        content = atlas_tunnel;
        type = "CNAME";
        zone_id = getchoo_com;
      };

      getchoo_com_git = {
        name = "git";
        content = atlas_tunnel;
        type = "CNAME";
        zone_id = getchoo_com;
      };

      getchoo_com_keyoxide = {
        name = "@";
        content = "$argon2id$v=19$m=512,t=256,p=1$AlA6W5fP7J14zMsw0W5KFQ$EQz/NCE0/TQpE64r2Eo/yOpjtMZ9WXevHsv3YYP7CXg";
        type = "TXT";
        zone_id = getchoo_com;
      };
    }
    // blockEmailSpoofingFor "getchoo_com";
}
