{
  inputs,
  self,
  ...
}: let
  inherit (inputs) hercules-ci-effects nixpkgs;
in {
  imports = [
    hercules-ci-effects.flakeModule
  ];

  hercules-ci = {
    flake-update = {
      enable = true;
      when = {
        hour = [0];
        minute = 0;
      };
    };
  };

  herculesCI = let
    inherit (import (hercules-ci-effects + "/vendor/hercules-ci-agent/default-herculesCI-for-flake.nix")) flakeToOutputs;
  in rec {
    ciSystems = [
      "x86_64-linux"
      "aarch64-linux"
    ];

    onPush = {
      default = {
        outputs = with builtins;
        with nixpkgs.lib; let
          # use defaults, but only evaluate hosts
          defaults =
            removeAttrs
            (flakeToOutputs self {
              ciSystems = genAttrs ciSystems (_: {});
            })
            ["nixosConfigurations" "packages"];

          evaluate = mapAttrs (_: v:
            seq
            v.config.system.build.toplevel
            v._module.args.pkgs.emptyFile)
          self.nixosConfigurations;
        in
          mkForce (defaults // evaluate);
      };
    };
  };
}
