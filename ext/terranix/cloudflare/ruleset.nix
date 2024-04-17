{lib, ...}: {
  resource.cloudflare_ruleset = {
    mydadleft_me_redirects = {
      kind = "zone";
      name = "default";
      phase = "http_request_dynamic_redirect";
      zone_id = lib.tfRef "var.mydadleft_me_zone_id";

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
