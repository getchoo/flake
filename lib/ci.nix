_: {
  toTopLevel = cfg: cfg.config.system.build.toplevel or cfg.activationPackage;
  isCompatibleWith = system: cfg: cfg.pkgs.system == system;
}
