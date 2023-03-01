{home-manager, ...}: {
  host = import ./host.nix {};
  user = import ./user.nix {inherit home-manager;};
}
