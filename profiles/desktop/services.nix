_: {
  services = {
    dbus = {
      enable = true;
      apparmor = "enabled";
    };
    pipewire = {
      enable = true;
      wireplumber.enable = true;
      alsa.enable = true;
      jack.enable = true;
      pulse.enable = true;
    };
  };
  hardware.pulseaudio.enable = false;
}
