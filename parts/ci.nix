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
    inputs.effects.flakeModule
  ];

  herculesCI = {lib, ...} @ herculesCI: {
    inherit ciSystems;

    onPush.default = let
      inherit (builtins) elem;
      inherit (lib) filterAttrs mapAttrs mkForce;

      amd64 = ["x86_64-linux"];

      findCompatible = systems: filterAttrs (s: _: elem s systems);
      findCompatibleCfgs = systems: filterAttrs (_: v: elem v.pkgs.system systems);
      buildCfgs = mapAttrs (_: v: v.config.system.build.toplevel);
      buildHMUsers = mapAttrs (_: mapAttrs (_: v: v.activationPackage));
      #evalCfgs = mapAttrs (_: v: seq v.config.system.build.toplevel v.pkgs.emptyFile);
    in
      mkForce {
        outputs = {
          checks = findCompatible amd64 self.checks;
          devShells = findCompatible amd64 self.devShells;
          homeConfigurations = buildHMUsers (findCompatible amd64 self.homeConfigurations);
          nixosConfigurations = buildCfgs (findCompatibleCfgs ciSystems self.nixosConfigurations);
        };
      };

    onSchedule = let
      when = {
        hour = [0];
        minute = 0;
      };

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
    in {
      nixpkgs-update = {
        inherit when;

        outputs.effects = {
          update = mkUpdateEffect ["nixpkgs" "nixpkgs-stable"] "flake: update nixpkgs inputs";
        };
      };

      flake-update = {
        when = when // {dayOfMonth = [1 8 15 22 29];};

        outputs.effects = {
          update = mkUpdateEffect [] "flake: update all inputs";
        };
      };
    };
  };
}
