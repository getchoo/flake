{
  lib,
  ...
}:
{
  # TODO: Actually configure zellij
  imports = [
    (lib.mkAliasOptionModule
      [
        "seth"
        "programs"
        "zellij"
      ]
      [
        "programs"
        "zellij"
      ]
    )
  ];
}
