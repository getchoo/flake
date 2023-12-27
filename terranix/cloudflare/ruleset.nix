{lib, ...}: {
  resource.cloudflare_ruleset = {
    default = {
      kind = "zone";
      name = "default";
      phase = "http_config_settings";
      zone_id = lib.tfRef "var.zone_id";

      rules = [
        {
          action = "set_config";
          action_parameters = {
            automatic_https_rewrites = true;
            email_obfuscation = true;
            opportunistic_encryption = false;
          };
          description = "base redirects";
          enabled = true;
          expression = "true";
        }
      ];
    };

    redirect = {
      kind = "zone";
      name = "default";
      phase = "http_request_dynamic_redirect";
      zone_id = lib.tfRef "var.zone_id";

      rules = [
        {
          action = "redirect";
          action_parameters = {
            from_value = {
              preserve_query_string = false;
              status_code = 301;
              target_url = {
                value = "https://www.youtube.com/watch?v=RvVdFXOFcjw";
              };
            };
          };
          description = "funny";
          enabled = true;
          expression = "(http.request.uri.path eq \"/hacks\" and http.host eq \"mydadleft.me\")";
        }
        {
          action = "redirect";
          action_parameters = {
            from_value = {
              preserve_query_string = false;
              status_code = 301;
              target_url = {
                value = "https://www.youtube.com/watch?v=RvVdFXOFcjw";
              };
            };
          };
          description = "onlyfriends";
          enabled = true;
          expression = "(http.request.uri.path eq \"/onlyfriends\" and http.host eq \"mydadleft.me\")";
        }
      ];
    };
  };
}
