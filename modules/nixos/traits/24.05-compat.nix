{lib, ...}: {
  imports = lib.optionals (lib.versionOlder lib.version "24.11pre") [
    (lib.mkAliasOptionModule ["hardware" "graphics" "extraPackages"] ["hardware" "opengl" "extraPackages"])
  ];
}
