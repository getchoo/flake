{
  programs = {
    gh = {
      enable = true;
      settings = {
        git_protocol = "https";
        editor = "nvim";
        prompt = "enabled";
        # workaround for https://github.com/nix-community/home-manager/issues/474
        version = 1;
      };

      gitCredentialHelper = {
        enable = true;
        hosts = ["https://github.com" "https://github.example.com"];
      };
    };

    git = {
      enable = true;

      difftastic = {
        enable = true;
        background = "dark";
        display = "inline";
      };

      extraConfig = {
        init = {defaultBranch = "main";};
      };

      signing = {
        key = "D31BD0D494BBEE86";
        signByDefault = true;
      };

      userEmail = "getchoo@tuta.io";
      userName = "seth";
    };
  };
}
