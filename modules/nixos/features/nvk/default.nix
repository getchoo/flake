{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.features.nvk;

  mkMesa = pkgs:
    (pkgs.mesa.override {
      vulkanDrivers =
        if pkgs.stdenv.isLinux
        then
          [
            "amd" # AMD (aka RADV)
            "microsoft-experimental" # WSL virtualized GPU (aka DZN/Dozen)
            "swrast" # software renderer (aka Lavapipe)
            "nouveau-experimental" # nvk
          ]
          ++ lib.optionals (pkgs.stdenv.hostPlatform.isAarch -> lib.versionAtLeast pkgs.stdenv.hostPlatform.parsed.cpu.version "6") [
            # QEMU virtualized GPU (aka VirGL)
            # Requires ATOMIC_INT_LOCK_FREE == 2.
            "virtio"
          ]
          ++ lib.optionals pkgs.stdenv.isAarch64 [
            "broadcom" # Broadcom VC5 (Raspberry Pi 4, aka V3D)
            "freedreno" # Qualcomm Adreno (all Qualcomm SoCs)
            "imagination-experimental" # PowerVR Rogue (currently N/A)
            "panfrost" # ARM Mali Midgard and up (T/G series)
          ]
          ++ lib.optionals pkgs.stdenv.hostPlatform.isx86 [
            "intel" # Intel (aka ANV), could work on non-x86 with PCIe cards, but doesn't build
            "intel_hasvk" # Intel Haswell/Broadwell, "legacy" Vulkan driver (https://www.phoronix.com/news/Intel-HasVK-Drop-Dead-Code)
          ]
        else ["auto"];
    })
    .overrideAttrs (new: old: let
      replacePatches = patch:
        {
          "opencl.patch" = ./opencl.patch;
          "disk_cache-include-dri-driver-path-in-cache-key.patch" = ./disk_cache-include-dri-driver-path-in-cache-key.patch;
        }
        .${baseNameOf patch}
        or patch;
    in {
      version = "23.3.1";

      src = pkgs.fetchurl {
        urls = [
          "https://archive.mesa3d.org/mesa-${new.version}.tar.xz"
          "https://mesa.freedesktop.org/archive/mesa-${new.version}.tar.xz"
        ];

        hash = "sha256-bkgSbXD9s/IP/rJGygwuQf/cg18GY6A9RSa4v120HeY=";
      };

      patches = map replacePatches old.patches;
    });
in {
  options.features.nvk.enable = lib.mkEnableOption "nvk";

  config = lib.mkIf cfg.enable {
    hardware.opengl = {
      package = (mkMesa pkgs).drivers;
      package32 = (mkMesa pkgs.pkgsi686Linux).drivers;
    };
  };
}
