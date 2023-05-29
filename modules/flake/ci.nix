{
  config,
  inputs,
  myLib,
  self,
  withSystem,
  ...
}: let
  mkUpdateEffect = herculesCI: inputs: pullRequestTitle: let
    cfg = config.hercules-ci.flake-update;
  in
    withSystem cfg.effect.system ({hci-effects, ...}:
      hci-effects.flakeUpdate {
        gitRemote = herculesCI.config.repo.remoteHttpUrl;
        user = "x-access-token";
        autoMergeMethod = "rebase";
        commitSummary = pullRequestTitle;
        inherit pullRequestTitle inputs;
        inherit (cfg) updateBranch forgeType createPullRequest pullRequestBody;
      });
in {
  imports = [
    inputs.hercules-ci-effects.flakeModule
  ];

  herculesCI = {lib, ...} @ herculesCI: let
    inherit (lib) mkForce;
    ciSystems = [
      "x86_64-linux"
      "aarch64-linux"
    ];
  in {
    inherit ciSystems;

    onPush = {
      default = {
        outputs = with (myLib.ci ciSystems);
          mkForce {
            apps = mkCompatibleApps self.apps;
            checks = mkCompatible self.checks;
            devShells = mkCompatible self.devShells;
            formatter = mkCompatibleFormatters self.formatter;
            homeConfigurations = mkCompatibleHM self.homeConfigurations;
            hosts = mkCompatibleCfg' self.nixosConfigurations;
          };
      };
    };

    onSchedule = let
      mkUpdateEffect' = mkUpdateEffect herculesCI;
    in {
      nixpkgs-update = {
        when = {
          hour = [0];
          minute = 0;
        };

        outputs = {
          effects.nixpkgs-update = mkUpdateEffect' ["nixpkgs" "nixpkgs-stable"] "flake: update nixpkgs inputs";
        };
      };

      flake-update = mkForce {
        when = {
          dayOfMonth = [1 8 15 22 29];
          hour = [0];
          minute = 0;
        };

        outputs = {
          effects.flake-update = mkUpdateEffect' [] "flake: update all inputs";
        };
      };
    };
  };
}
