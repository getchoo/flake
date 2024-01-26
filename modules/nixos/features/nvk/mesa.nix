/*
thanks to the chaotic-cx LUG for their mesa-git expression, it inspired some of this
https://github.com/chaotic-cx/nyx/blob/a4e9fa0795880c3330d9f86cab466a7402d6d4f5/pkgs/mesa-git/default.nix

MIT License

Copyright (c) 2023 Pedro Henrique Lara Campos <nyx@pedrohlc.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/
{
  lib,
  pkgs,
  ...
}: let
  cargoDeps = {
    proc-macro2 = {
      version = "1.0.70";
      hash = "sha256-OSePu/X7T2Rs5lFpCHf4nRxYEaPUrLJ3AMHLPNt4/Ts=";
    };
    quote = {
      version = "1.0.33";
      hash = "sha256-Umf8pElgKGKKlRYPxCOjPosuavilMCV54yLktSApPK4=";
    };
    syn = {
      version = "2.0.39";
      hash = "sha256-I+eLkPL89F0+hCAyzjLj8tFUW6ZjYnHcvyT6MG2Hvno=";
    };
    unicode-ident = {
      version = "1.0.12";
      hash = "sha256-M1S5rD+uH/Z1XLbbU2g622YWNPZ1V5Qt6k+s6+wP7ks=";
    };
  };
  mesa =
    (pkgs.mesa.override {
      # we use the new flag for this
      enablePatentEncumberedCodecs = false;

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
    .overrideAttrs (new: old: {
      version = "24.0.0";

      src = pkgs.fetchurl {
        urls = [
          "https://archive.mesa3d.org/mesa-${new.version}.tar.xz"
          "https://mesa.freedesktop.org/archive/mesa-${new.version}.tar.xz"
        ];

        hash = "sha256-YoWlu7v0P92vtLO3JrFIpKIiRg6JK9G2mq/004DJg1U=";
      };

      nativeBuildInputs = old.nativeBuildInputs ++ [pkgs.rustc pkgs.rust-bindgen];

      patches = let
        badPatches = [
          "0001-dri-added-build-dependencies-for-systems-using-non-s.patch"
          "0002-util-Update-util-libdrm.h-stubs-to-allow-loader.c-to.patch"
          "0003-glx-fix-automatic-zink-fallback-loading-between-hw-a.patch"
        ];
      in
        lib.filter (patch: !(lib.elem (baseNameOf patch) badPatches)) old.patches;

      postPatch = let
        cargoFetch = crate:
          pkgs.fetchurl {
            url = "https://crates.io/api/v1/crates/${crate}/${cargoDeps.${crate}.version}/download";
            inherit (cargoDeps.${crate}) hash;
          };

        cargoSubproject = crate: ''
          ln -s ${cargoFetch crate} subprojects/packagecache/${crate}-${cargoDeps.${crate}.version}.tar.gz
        '';

        subprojects = lib.concatMapStringsSep "\n" cargoSubproject (lib.attrNames cargoDeps);
      in
        old.postPatch
        + ''
          mkdir subprojects/packagecache
          ${subprojects}
        '';

      mesonFlags = old.mesonFlags ++ lib.optional (!pkgs.stdenv.hostPlatform.is32bit) "-D video-codecs=all";
    });
in
  mesa
