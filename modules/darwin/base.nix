{
  lib,
  inputs,
  ...
}: {
  imports = [../shared];

  # not sure why i have to force this
  environment.etc."nix/inputs/nixpkgs".source = lib.mkForce inputs.nixpkgs.outPath;

  programs = {
    bash.enable = true;
    vim.enable = true;
    zsh.enable = true;
  };

  services.nix-daemon.enable = true;
}
