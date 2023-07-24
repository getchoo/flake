_: prev: {
  lua-language-server = prev.lua-language-server.overrideAttrs (old: {
    nativeBuildInputs =
      old.nativeBuildInputs
      ++ prev.lib.optional prev.stdenv.isDarwin prev.darwin.ditto;
  });
}
