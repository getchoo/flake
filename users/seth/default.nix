{inputs, ...}: {
  imports = [inputs.self.homeModules.seth];
  seth = {
    enable = true;
    standalone.enable = true;
  };
}
