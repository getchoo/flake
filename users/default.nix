inputs: system:
with inputs; {
  seth = {
    pkgs = import nixpkgsUnstable {
      inherit system;
      overlays = [nur.overlay getchoo.overlays.default];
    };

    stateVersion = "23.05";
  };
}
