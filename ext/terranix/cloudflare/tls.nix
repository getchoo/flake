{lib, ...}: let
  baseSettings = {
    always_use_https = "on";
    ssl = "strict";
  };
in {
  resource.cloudflare_zone_settings_override = {
    mydadleft_me_settings = {
      zone_id = lib.tfRef "var.mydadleft_me_zone_id";
      settings = baseSettings;
    };

    getchoo_com_settings = {
      zone_id = lib.tfRef "var.getchoo_com_zone_id";
      settings = baseSettings;
    };
  };
}
