{
  config,
  lib,
  ...
}: let
  cfg = config.getchoo.programs.git;
  inherit (lib) mkEnableOption mkIf;
in {
  options.getchoo.programs.git.enable = mkEnableOption "git" // {default = true;};

  config = mkIf cfg.enable {
    programs = {
      gh = {
        enable = true;
        settings = {
          git_protocol = "ssh";
          editor = "nvim";
          prompt = "enabled";
        };
      };

      git = {
        enable = true;

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
  };
}
