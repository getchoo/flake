{ inputs, self, ... }:
{
  perSystem =
    { system, ... }:
    {
      # as opposed to having system specific outputs like `apps.nixinate.mySystem`
      # we can instantiate this for each system and grab it's final attribute, `nixinate`
      #
      # this lets deployments be as easy as `nix run .#mySystem`
      apps = (inputs.nixinate.nixinate.${system} self).nixinate;
    };
}
