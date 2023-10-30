{inputs, ...}: let
  channelPath = i: "${inputs.${i}.outPath}";
  mapInputs = fn: map fn (builtins.filter (n: n != "self") (builtins.attrNames inputs));
in {
  imports = [../shared];

  nix.nixPath =
    mapInputs (i: "${i}=${channelPath i}");

  programs = {
    bash.enable = true;
    vim.enable = true;
    zsh.enable = true;
  };

  services.nix-daemon.enable = true;
}
