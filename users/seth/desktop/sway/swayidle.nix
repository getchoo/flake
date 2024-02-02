{
  config,
  lib,
  ...
}: {
  services.swayidle = let
    getSwayExe = lib.getExe' config.wayland.windowManager.sway.package;
    swaymsg = getSwayExe "swaymsg";
    swaylock = getSwayExe "swaylock";
  in {
    enable = true;
    extraArgs = ["-d"];
    events = [
      {
        event = "before-sleep";
        command = "${swaylock}; ${swaymsg} 'output * power on'";
      }
      {
        event = "after-resume";
        command = "${swaymsg} 'output * power on'";
      }
    ];

    timeouts = [
      {
        timeout = 120;
        command = "${swaymsg} 'output * power off'";
        resumeCommand = "${swaymsg} 'output * power on'";
      }
    ];
  };
}
