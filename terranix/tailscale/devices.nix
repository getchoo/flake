{lib, ...}: {
  data.tailscale_device = let
    toDevices = devices:
      lib.genAttrs devices (name: {
        name = "${name}.tailc59d6.ts.net";
        wait_for = "60s";
      });
  in
    toDevices [
      "atlas"
      "caroline"
      "glados"
      "glados-wsl"
      "glados-windows"
      "iphone-14"
    ];
}
