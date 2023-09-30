{
  inputs,
  root,
  ...
}:
root.utils.nixpkgsFor."x86_64-linux".callPackage ./configuration.nix {
  inherit (inputs) openwrt-imagebuilder;
}
