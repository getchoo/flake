{pkgs, ...}: let
  uploadToCachix = pkgs.writeScriptBin "upload-to-cachix" ''
    #!/bin/sh
    set -euf

    OUT_END=$(echo ''${OUT_PATHS: -10})
    if [ "$OUT_END" == "-spec.json" ]; then
    exit 0
    fi

    export HOME=/root
    exec ${pkgs.cachix}/bin/cachix -c /etc/cachix/cachix.dhall push getchoo $OUT_PATHS > /tmp/hydra_cachix 2>&1
  '';
in {
  nix.extraOptions = ''
    post-build-hook = ${uploadToCachix}/bin/upload-to-cachix
  '';
}
