lib: supportedSystems: let
  inherit (builtins) attrNames baseNameOf elem getContext head mapAttrs seq stringLength substring;
  inherit (lib) filterAttrs;
  check = string: elem string supportedSystems;
in rec {
  # filters systems in basic flake output
  # ex:
  #
  #	packages = {
  #	  x86_64-linux = {};
  #	  aarch64-linux = {};
  #	  x86_64-darwin = {};
  #	  aarch64-darwin = {};
  #	};
  # mkCompatible packages -> {x86_64-linux = {}; aarch64-linux = {};}
  mkCompatible = filterAttrs (system: _: check system);

  # mkCompatible but for apps, since their attribute
  # also needs to be editied in order to be picked up
  # by hydra
  mkCompatibleApps = apps:
    mkCompatible (mapAttrs (
        _:
          mapAttrs (_: v: {
            program = let
              ctx = getContext v.program;
              drvPath = head (attrNames ctx);
              basename = baseNameOf drvPath;
              hashLength = 33;
              l = stringLength basename;
            in {
              name = substring hashLength (l - hashLength - 4) basename;
              type = "derivation";
              inherit drvPath;
            };
          })
      )
      apps);

  # mkCompatible but for formatters
  mkCompatibleFormatters = filterAttrs (system: fmt: check system && elem system (fmt.meta.platforms or []));

  # mkComaptible, but maps nixosConfigurations
  # to their toplevel build attribute so they can
  # be picked up by hydra
  mkCompatibleCfg = configs:
    filterAttrs (_: config: check config.system)
    (mapAttrs (_: v: v.config.system.build.toplevel) configs);

  # mkCompatibleCfg, but the toplevel build attribute
  # is only evaluated
  mkCompatibleCfg' = configs:
    filterAttrs (_: config: check config.system)
    (mapAttrs (_: v:
      seq
      v.config.system.build.toplevel
      v._module.args.pkgs.emptyFile)
    configs);

  # mkCompatible, but maps homeConfigurations
  # to their activationPackage so they can be
  # picked up by hydra
  mkCompatibleHM = configs:
    filterAttrs (system: _: check system)
    (mapAttrs (_: mapAttrs (_: deriv: deriv.activationPackage or {})) configs);

  # mkCompatible, but for packages
  # meta.platforms is also checked to ensure compatibility
  mkCompatiblePkgs = mapAttrs (system: filterAttrs (_: deriv: elem system (deriv.meta.platforms or [])));
}
