system: inputs:
with inputs; {
  seth = {
    pkgs = import nixpkgsUnstable {
      inherit system;
      overlays = [nur.overlay getchoo.overlays.default];
    };
    modules = [];
    extraSpecialArgs = {};
  };
}
