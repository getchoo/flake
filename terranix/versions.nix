{lib, ...}: {
  terraform.required_providers = let
    registry = "registry.terraform.io";

    fmtSource = _: value:
      lib.recursiveUpdate value {
        source = "${registry}/${value.source}";
      };
  in
    lib.mapAttrs fmtSource {
      cloudflare.source = "cloudflare/cloudflare";

      tailscale.source = "tailscale/tailscale";
    };
}
