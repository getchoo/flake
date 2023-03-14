_: {
  networking.networkmanager = {
    enable = true;
    dns = "systemd-resolved";
  };
}
