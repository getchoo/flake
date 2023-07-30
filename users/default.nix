{
  inputs,
  myLib,
  self,
  ...
}: {
  perSystem = {system, ...}: let
    inherit (myLib.configs inputs) mkHMUsers;
    ci = myLib.ci [system];
  in {
    homeConfigurations = mkHMUsers {
      seth = {
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = with inputs; [nur.overlay getchoo.overlays.default];
        };
        modules = [
          {_module.args.osConfig = {};}
          inputs.nix-index-database.hmModules.nix-index
        ];
      };
    };

    packages = (ci.mkCompatibleHM self.homeConfigurations).${system};
  };
}
