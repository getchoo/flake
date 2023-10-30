{
  programs = {
    gh = {
      enable = true;
      settings = {
        git_protocol = "https";
        editor = "nvim";
        prompt = "enabled";
      };

      gitCredentialHelper = {
        enable = true;
        hosts = ["https://github.com" "https://github.example.com"];
      };
    };

    git = {
      enable = true;

      delta = {
        enable = true;
        options = {
          syntax-theme = "Catppuccin-mocha";
        };
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
