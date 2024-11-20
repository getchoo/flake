{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.seth.programs.jujutsu;
in
{
  options.seth.programs.jujutsu = {
    enable = lib.mkEnableOption "jujutsu configuration settings" // {
      default = config.seth.enable;
      defaultText = lib.literalExpression "config.seth.enable";
    };
  };

  # TODO: Configure
  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.enable -> (config.seth.programs.git.enable && config.seth.programs.gh.enable);
        message = "`seth.programs.git` and `seth.programs.gh` are required to use `seth.programs.jujutsu`";
      }
    ];

    programs = {
      jujutsu = {
        enable = true;

        settings = {
          user = {
            name = "seth";
            email = "getchoo@tuta.io";
          };

          signing = {
            sign-all = true;
            backend = "gpg";
            key = "D31BD0D494BBEE86";
          };
        };
      };
    };
  };
}
