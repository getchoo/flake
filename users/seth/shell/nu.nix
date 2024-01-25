{
  config,
  lib,
  inputs,
  ...
}: let
  theme = "catppuccin-${config.catppuccin.flavour}";
in {
  programs = {
    nushell = {
      enable = true;

      configFile.text = ''
        def "nixgc" [] {
          sudo nix-collect-garbage -d; nix-collect-garbage -d
        }
      '';

      envFile.text = ''
        use ${inputs.nu-scripts}/themes/nu-themes/${theme}.nu
        $env.config.color_config = (${theme})
      '';

      inherit (config.home) shellAliases;
    };

    bash.initExtra = lib.mkAfter ''
      if [[ $(ps --no-header --pid=$PPID --format=comm) != "nu" && -z ''${BASH_EXECUTION_STRING} ]]; then
         exec ${lib.getExe config.programs.nushell.package}
      fi
    '';

    # builtin `ls` is good here!
    eza.enable = lib.mkForce false;
  };
}
