{ lib, ... }:
let
  getGitHubRepo =
    { owner, repo_name }:
    {
      type = "github";
      config = {
        inherit owner repo_name;
        production_branch = "main";
      };
    };
in
{
  resource.cloudflare_pages_project = {
    personal_website = {
      account_id = lib.tfRef "var.account_id";
      name = "getchoo-website";
      production_branch = "main";

      source = getGitHubRepo {
        owner = "getchoo";
        repo_name = "website";
      };

      build_config = {
        build_caching = true;
        build_command = "./build-site.sh";
        destination_dir = "/dist";
      };

      deployment_configs =
        let
          environment_variables = {
            ZOLA_VERSION = "0.19.2";
          };
        in
        {
          production = [ { inherit environment_variables; } ];
          preview = [ { inherit environment_variables; } ];
        };
    };

    teawie_api = {
      account_id = lib.tfRef "var.account_id";
      name = "teawie-api";
      production_branch = "main";

      source = getGitHubRepo {
        owner = "getchoo";
        repo_name = "teawieAPI";
      };

      build_config = {
        build_caching = true;
        build_command = "pnpm run lint && pnpm run build";
        destination_dir = "/dist";
      };
    };
  };
}
