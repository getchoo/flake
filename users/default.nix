{ self, withSystem, ... }:
{
  flake.homeConfigurations =
    let
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
