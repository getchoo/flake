{
  config,
  inputs,
  self,
  withSystem,
  ...
}: let
  ciSystems = [
    "x86_64-linux"
    "aarch64-linux"
  ];
in {
  imports = [
    inputs.hercules-ci-effects.flakeModule
  ];

  herculesCI = {lib, ...} @ herculesCI: {
    inherit ciSystems;

    onPush.default = let
      inherit (builtins) elem seq;
      inherit (lib) filterAttrs mapAttrs mkForce;

      findCompatible = filterAttrs (s: _: elem s ciSystems);
      findCompatible' = filterAttrs (_: v: elem v.pkgs.system ciSystems);
      findSystem = system: filterAttrs (s: _: s == system);
      #buildCfgs = mapAttrs (_: v: v.config.system.build.toplevel);
      evalCfgs = mapAttrs (_: v: seq v.config.system.build.toplevel v.pkgs.emptyFile);
    in
      mkForce {
        outputs = {
          checks = findCompatible self.checks;
          devShells = findSystem "x86_64-linux" self.devShells;
          homeConfigurations = findSystem "x86_64-linux" self.homeConfigurations;
          nixosConfigurations = evalCfgs (findCompatible' self.nixosConfigurations);
        };
      };

    onSchedule = let
      inherit (lib) mkForce mapAttrs optionalAttrs;

      mkUpdateEffect = inputs: pullRequestTitle: let
        cfg = config.hercules-ci.flake-update;
      in
        withSystem cfg.effect.system ({hci-effects, ...}:
          hci-effects.flakeUpdate {
            gitRemote = herculesCI.config.repo.remoteHttpUrl;
            user = "x-access-token";
            autoMergeMethod = "rebase";
            commitSummary = pullRequestTitle;
            module = cfg.effect.settings;
            inherit pullRequestTitle inputs;
            inherit (cfg) updateBranch forgeType createPullRequest pullRequestBody;
          });

      mkUpdates = mapAttrs (n: {
        inputs ? [],
        dayOfMonth ? [],
        msg ? "all",
      }:
        mkForce {
          when =
            {
              hour = [0];
              minute = 0;
            }
            // optionalAttrs (dayOfMonth != []) {inherit dayOfMonth;};

          outputs = {
            effects.${n} = mkUpdateEffect inputs "flake: update ${msg} inputs";
          };
        });
    in
      mkUpdates {
        nixpkgs-update = {
          inputs = ["nixpkgs" "nixpkgs-stable"];
          msg = "nixpkgs";
        };

        flake-update = {
          dayOfMonth = [1 8 15 22 29];
          msg = "all";
        };
      };
  };
}
