{
  config,
  self,
  ...
}: let
  hydraUser = config.users.users.hydra.name;
  hydraGroup = config.users.users.hydra.group;
  inherit (config.networking) domain hostName;
in {
  config = {
    age.secrets = let
      commonArgs = {
        mode = "440";
        owner = hydraUser;
        group = hydraGroup;
      };
    in {
      "${hostName}2atlas" =
        {
          file = "${self}/secrets/hosts/${hostName}/${hostName}2atlas.age";
        }
        // commonArgs;

      "hydraGH" =
        {
          file = "${self}/secrets/hosts/${hostName}/hydraGH.age";
        }
        // commonArgs;
    };

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
  };
}
