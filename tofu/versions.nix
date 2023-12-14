{
  terraform.required_providers = {
    cloudflare = {
      source = "registry.terraform.io/cloudflare/cloudflare";
      version = "~> 4";
    };

    tailscale = {
      source = "registry.terraform.io/tailscale/tailscale";
      version = "0.13.13";
    };
  };
}
