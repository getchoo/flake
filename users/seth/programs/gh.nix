{
  config,
  lib,
  ...
}:
let
  cfg = config.seth.programs.gh;
in
{
  options.seth.programs.gh = {
    enable = lib.mkEnableOption "GitHub CLI" // {
      default = config.seth.programs.git.enable;
      defaultText = "config.seth.programs.git.enable";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gh = {
      enable = true;

      settings = {
        git_protocol = "https";
        editor = "nvim";
        prompt = "enabled";
      };

      gitCredentialHelper = {
        enable = true;
        hosts = [
          "https://github.com"
          "https://github.example.com"
        ];
      };
    };
  };
}
