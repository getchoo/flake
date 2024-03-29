{lib, ...}: {
  imports = [
    ./dns.nix
    ./ruleset.nix
    ./tunnels.nix
  ];

  resource = {
    cloudflare_url_normalization_settings.incoming = {
      scope = "incoming";
      type = "cloudflare";
      zone_id = lib.tfRef "var.zone_id";
    };

    cloudflare_bot_management.bots = {
      enable_js = false;
      fight_mode = false;
      zone_id = lib.tfRef "var.zone_id";
    };
  };
}
