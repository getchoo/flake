# TODO: Upstream this
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.git.riff;
  cfg' = config.programs.git;

  exe = baseNameOf (lib.getExe cfg.package);
in
{
  options.programs.git.riff = {
    enable = lib.mkEnableOption "diff filtering through riff";
    package = lib.mkPackageOption pkgs "riffdiff" { };
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion =
          let
            enabled = [
              cfg'.delta.enable
              cfg'.diff-so-fancy.enable
              cfg'.difftastic.enable
              cfg.enable
            ];
          in
          lib.count lib.id enabled <= 1;
        message = "Only one of 'programs.git.delta.enable' or 'programs.git.difftastic.enable' or 'programs.git.diff-so-fancy.enable' or `programs.git.riff.enable` can be set to true at the same time.";
      }
    ];

    home.packages = [ cfg.package ];

    programs.git.iniContent = {
      pager = {
        diff = exe;
        log = exe;
        show = exe;
      };

      interactive.diffFilter = exe + " --color=on";
    };
  };
}
