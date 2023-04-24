{
  config,
  guzzle_api,
  hercules-ci-agent,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/virtualisation/digital-ocean-image.nix")
    hercules-ci-agent.nixosModules.agent-service
  ];

  base = {
    enable = true;
    documentation.enable = false;
    defaultPackages.enable = false;
  };

  nixos = {
    enable = true;
    networking.enable = false;
  };

  networking = {
    hostName = "p-body";
    firewall = let
      ports = [80 420];
    in {
      allowedUDPPorts = ports;
      allowedTCPPorts = ports;
    };
  };

  programs = {
    git.enable = true;
    vim.defaultEditor = true;
  };

  security = {
    pam.enableSSHAgentAuth = true;
  };

  services = {
    #caddy = {
    #  enable = true;

    #  email = "getchoo@tuta.io";

    #  logFormat = ''
    #    output stdout
    #    format json
    #  '';

    #  extraConfig = ''
    #    (strip-www) {
    #    	redir https://{args.0}{uri}
    #    }

    #    (common_domain) {
    #    	encode gzip

    #    	handle {
    #    		try_files {path} {path}/
    #    	}

    #    	handle_errors {
    #    		@404 {
    #    			expression {http.error.status_code} == 404
    #    		}
    #    		rewrite @404 /404.html
    #    		file_server
    #    	}
    #    }

    #    (no_embeds) {
    #    	header /{args.0} X-Frame-Options DENY
    #    }

    #    (container_proxy) {
    #    	handle_path /{args.0}/* {
    #    		reverse_proxy {args.1}
    #    	}
    #    }
    #  '';

    #  globalConfig = ''
    #    auto_https off
    #  '';

    #  virtualHosts = {
    #    guzzle = rec {
    #      hostName = "167.99.145.73";

    #      serverAliases = [
    #        "www.${hostName}"
    #      ];

    #      extraConfig = ''
    #        root * /var/www
    #        import common_domain

    #        file_server

    #        import container_proxy api :8000
    #      '';

    #      listenAddresses = [
    #        "127.0.0.1"
    #        "::1"
    #      ];
    #    };
    #  };
    #};

    endlessh = {
      enable = true;
      port = 22;
      openFirewall = true;
    };

    guzzle-api = {
      enable = true;
      url = "http://167.99.145.73";
      port = "80";
      package = guzzle_api.packages.x86_64-linux.guzzle-api-server;
    };

    hercules-ci-agent.enable = true;

    openssh = {
      enable = true;
      passwordAuthentication = false;
      ports = [420];
    };
  };

  swapDevices = [
    {
      device = "/swapfile";
    }
  ];

  system.stateVersion = "22.11";

  users.users = let
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOeEbjzzzwf9Qyl0JorokhraNYG4M2hovyAAaA6jPpM7 seth@glados"
    ];
  in {
    root = {inherit openssh;};
    p-body = {
      extraGroups = ["wheel"];
      isNormalUser = true;
      shell = pkgs.bash;
      passwordFile = config.age.secrets.pbodyPassword.path;
      inherit openssh;
    };
  };

  zramSwap.enable = true;
}
