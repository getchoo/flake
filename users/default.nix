{ self, withSystem, ... }:
{
  flake.homeConfigurations =
    let
      # see ./lib/builders.nix
      inherit (self.lib) homeManagerConfiguration;

      pkgsFor = system: withSystem system ({ pkgs, ... }: pkgs);
    in
    {
      seth = homeManagerConfiguration {
        pkgs = pkgsFor "x86_64-linux";
        modules = [ ./seth/home.nix ];
      };
    };
}
