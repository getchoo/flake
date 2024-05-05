{lib, ...}: let
  mkRecord = {
    name,
    value,
    type,
    zone_id,
  }:
    {
      inherit name value type zone_id;
      ttl = 1;
    }
    // lib.optionalAttrs (type != "TXT") {proxied = true;};

  zones = {
    mydadleft_me = lib.tfRef "var.mydadleft_me_zone_id";
    getchoo_com = lib.tfRef "var.getchoo_com_zone_id";
  };
  inherit
    (zones)
    mydadleft_me
    getchoo_com
    ;

  atlas_tunnel = lib.tfRef "data.cloudflare_tunnel.atlas-nginx.id" + ".cfargotunnel.com";

  pagesSubdomainFor = project: lib.tfRef "resource.cloudflare_pages_project.${project}.subdomain";
  blockEmailSpoofingFor = domain: let
    zone_id = zones.${domain};
  in {
    "${domain}_dmarc" = {
      name = "_dmarc";
      value = "v=DMARC1; p=reject; sp=reject; adkim=s; aspf=s;";
      type = "TXT";
      inherit zone_id;
    };

    "${domain}_domainkey" = {
      name = "*._domainkey";
      value = "v=DKIM1; p=";
      type = "TXT";
      inherit zone_id;
    };

    "${domain}_email" = {
      name = "@";
      value = "v=spf1 -all";
      type = "TXT";
      inherit zone_id;
    };
  };
in {
  resource.cloudflare_zone_dnssec = {
    mydadleft_me_dnssec = {
      zone_id = mydadleft_me;
    };

    getchoo_com_dnssec = {
      zone_id = getchoo_com;
    };
  };

  resource.cloudflare_record =
    lib.mapAttrs (_: mkRecord) {
      getchoo_com_website = {
        name = "@";
        value = pagesSubdomainFor "personal_website";
        type = "CNAME";
        zone_id = getchoo_com;
      };

      getchoo_com_www = {
        name = "www";
        value = "getchoo.com";
        type = "CNAME";
        zone_id = getchoo_com;
      };

      getchoo_com_api = {
        name = "api";
        value = pagesSubdomainFor "teawie_api";
        type = "CNAME";
        zone_id = getchoo_com;
      };

      getchoo_com_miniflux = {
        name = "miniflux";
        value = atlas_tunnel;
        type = "CNAME";
        zone_id = getchoo_com;
      };

      getchoo_com_keyoxide = {
        name = "@";
        value = "$argon2id$v=19$m=512,t=256,p=1$AlA6W5fP7J14zMsw0W5KFQ$EQz/NCE0/TQpE64r2Eo/yOpjtMZ9WXevHsv3YYP7CXg";
        type = "TXT";
        zone_id = getchoo_com;
      };

      mydadleft_me_website = {
        name = "@";
        value = pagesSubdomainFor "personal_website";
        type = "CNAME";
        zone_id = mydadleft_me;
      };

      mydadleft_me_keyoxide = {
        name = "@";
        value = "$argon2id$v=19$m=512,t=256,p=1$AlA6W5fP7J14zMsw0W5KFQ$EQz/NCE0/TQpE64r2Eo/yOpjtMZ9WXevHsv3YYP7CXg";
        type = "TXT";
        zone_id = mydadleft_me;
      };

      mydadleft_me_www = {
        name = "www";
        value = "mydadleft.me";
        type = "CNAME";
        zone_id = mydadleft_me;
      };

      mydadleft_me_api = {
        name = "api";
        value = pagesSubdomainFor "teawie_api";
        type = "CNAME";
        zone_id = mydadleft_me;
      };

      mydadleft_me_miniflux = {
        name = "miniflux";
        value = atlas_tunnel;
        type = "CNAME";
        zone_id = mydadleft_me;
      };
    }
    // blockEmailSpoofingFor "mydadleft_me"
    // blockEmailSpoofingFor "getchoo_com";
}
