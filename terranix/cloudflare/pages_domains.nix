{ lib, ... }:
let
  setDomainsFor =
    {
      account_id,
      project,
      domains,
    }:
    lib.listToAttrs (
      map (domain: {
        name = "${project}_${builtins.replaceStrings [ "." ] [ "_" ] domain}";
        value = {
          inherit account_id;
          project_name = lib.tfRef "resource.cloudflare_pages_project.${project}.name";
          inherit domain;
        };
      }) domains
    );
in
{
  resource.cloudflare_pages_domain =
    setDomainsFor {
      account_id = lib.tfRef "var.account_id";
      project = "personal_website";
      domains = [ "getchoo.com" ];
    }
    // setDomainsFor {
      account_id = lib.tfRef "var.account_id";
      project = "teawie_api";
      domains = [ "api.getchoo.com" ];
    };
}
