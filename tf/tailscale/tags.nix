{lib, ...}: {
  resource.tailscale_device_tags = let
    getDeviceID = device: lib.tfRef "data.tailscale_device.${device}.id";
    toTags = n: v: {device_id = getDeviceID n;} // v;

    tags = lib.genAttrs ["server" "personal" "gha"] (n: ["tag:${n}"]);
  in
    builtins.mapAttrs toTags {
      atlas.tags = tags.server;
      caroline.tags = tags.personal;
      glados.tags = tags.personal;
      glados-wsl.tags = tags.personal;
      iphone-14.tags = tags.personal;
    };
}
