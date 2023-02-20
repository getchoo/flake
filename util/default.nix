{ home-manager, ... }: {
  host = import ./host.nix { inherit home-manager; };
  user = import ./user.nix { inherit home-manager; };
}
