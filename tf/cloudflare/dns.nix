{lib, ...}: let
  mkRecord = name: {
    value,
    type,
    ...
  } @ args:
    {
      name = args.name or name;
      zone_id = lib.tfRef "var.zone_id";
      ttl = 1;
      inherit value type;
    }
    // lib.optionalAttrs (type != "TXT") {proxied = true;};

  atlas_tunnel = lib.tfRef "data.cloudflare_tunnel.atlas-nginx.id" + ".cfargotunnel.com";
in {
  resource.cloudflare_record = builtins.mapAttrs mkRecord {
    website = {
      name = "@";
      value = "website-86j.pages.dev";
      type = "CNAME";
    };

    www = {
      value = "mydadleft.me";
      type = "CNAME";
    };

    api = {
      value = "teawieapi.pages.dev";
      type = "CNAME";
    };

    cache = {
      value = atlas_tunnel;
      type = "CNAME";
    };

    miniflux = {
      value = atlas_tunnel;
      type = "CNAME";
    };

    msix = {
      value = atlas_tunnel;
      type = "CNAME";
    };

    # prevent email spoofing

    dmarc = {
      name = "_dmarc";
      value = "v=DMARC1; p=reject; sp=reject; adkim=s; aspf=s;";
      type = "TXT";
    };

    domainkey = {
      name = "*._domainkey";
      value = "v=DKIM1; p=";
      type = "TXT";
    };

    email = {
      name = "mydadleft.me";
      value = "v=spf1 -all";
      type = "TXT";
    };
  };
}
