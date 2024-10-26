{
  lib,
  ...
}:
{
  # TODO: Actually configure ncspot
  imports = [
    (lib.mkAliasOptionModule
      [
        "seth"
        "programs"
        "ncspot"
      ]
      [
        "programs"
        "ncspot"
      ]
    )
  ];
}
