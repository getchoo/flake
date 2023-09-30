_: {
  services = {
    journald.extraConfig = ''
      MaxRetentionSec=1w
    '';
  };
}
