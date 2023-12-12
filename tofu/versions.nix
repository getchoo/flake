{
  terraform.required_providers = {
    cloudflare = {
      source = "cloudflare/cloudflare";
      version = "~> 4";
    };

    tailscale = {
      source = "tailscale/tailscale";
      version = "0.13.13";
    };
  };
}
