{root, ...}: {
  caroline = with root.profiles.personal-darwin;
    builder {
      system = "x86_64-darwin";
      modules = modules ++ [./_caroline/configuration.nix];
      inherit specialArgs;
    };
}
