{
  lib,
  ...
}:
{
  # TODO: Actually configure yazi
  imports = [
    (lib.mkAliasOptionModule
      [
        "seth"
        "programs"
        "yazi"
      ]
      [
        "programs"
        "yazi"
      ]
    )
  ];
}
