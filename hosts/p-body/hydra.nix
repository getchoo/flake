{
  config,
  self,
  ...
}: let
  hydraGroup = config.users.users.hydra.group;
  inherit (config.networking) domain hostName;
in {
  age.secrets = {
    "hydraGH" = {
      file = "${self}/secrets/hosts/${hostName}/hydraGH.age";
      mode = "440";
      owner = config.users.users.hydra.name;
      group = hydraGroup;
    };
  };

  # https://github.com/NixOS/nix/issues/2002#issuecomment-375270656
  nix.extraOptions = ''
    allowed-uris = https:// http://
  '';

  services.hydra = {
    enable = true;
    hydraURL = "https://hydra.${domain}";
    notificationSender = "hydra@${domain}";
    listenHost = "localhost";
    port = 6000;
    useSubstitutes = true;
    extraConfig = ''
      Include ${config.age.secrets.hydraGH.path}

      compress_build_logs = 1
      queue_runner_metrics_address = 127.0.0.1:6002

      <githubstatus>
        jobs = .*
        excludeBuildFromContext = 1
        useShortContext = true
      </githubstatus>

      <hydra_notify>
        <prometheus>
          listen_address = 127.0.0.1
          port = 6001
        </prometheus>
      </hydra_notify>
    '';
    extraEnv = {HYDRA_DISALLOW_UNFREE = "0";};
  };

  nix.settings.trusted-users = ["@${hydraGroup}"];

  users.users = {
    hydra-queue-runner.extraGroups = [hydraGroup];
    hydra-www.extraGroups = [hydraGroup];
  };
}
