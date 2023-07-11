{
  inputs,
  myLib,
  ...
}: {
  perSystem = {system, ...}: let
    inherit (myLib.configs inputs) mkHMUsers;
  in {
    homeConfigurations = mkHMUsers {
      seth = {
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = with inputs; [nur.overlay getchoo.overlays.default];
        };
      };
    };
  };
}
