{pkgs, ...}: let
  ivsc-firmware = with pkgs;
    stdenv.mkDerivation rec {
      pname = "ivsc-firmware";
      version = "main";

      src = pkgs.fetchFromGitHub {
        owner = "intel";
        repo = "ivsc-firmware";
        rev = "10c214fea5560060d387fbd2fb8a1af329cb6232";
        sha256 = "sha256-kEoA0yeGXuuB+jlMIhNm+SBljH+Ru7zt3PzGb+EPBPw=";
      };

      installPhase = ''
        mkdir -p $out/lib/firmware/vsc/soc_a1_prod

        cp firmware/ivsc_pkg_ovti01a0_0.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_pkg_ovti01a0_0_a1_prod.bin
        cp firmware/ivsc_skucfg_ovti01a0_0_1.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_skucfg_ovti01a0_0_1_a1_prod.bin
        cp firmware/ivsc_fw.bin $out/lib/firmware/vsc/soc_a1_prod/ivsc_fw_a1_prod.bin
      '';
    };
in {
  # Tracking Issue: Intel MIPI/IPU6 webcam-support
  # https://github.com/NixOS/nixpkgs/issues/225743#issuecomment-1849613797
  # Infrastructure Processing Unit
  hardware.ipu6 = {
    enable = true;
    platform = "ipu6ep";
  };

  hardware.enableRedistributableFirmware = true;

  boot.kernelPackages = pkgs.linuxPackages_latest.extend ( self: super: {
    ipu6-drivers = super.ipu6-drivers.overrideAttrs (
        final: previous: rec {
          src = builtins.fetchGit {
            url = "https://github.com/intel/ipu6-drivers.git";
            ref = "master";
            rev = "b4ba63df5922150ec14ef7f202b3589896e0301a";
          };
          patches = [
            "${src}/patches/0001-v6.10-IPU6-headers-used-by-PSYS.patch"
          ] ;
        }
    );
  } );

  hardware.firmware = [
    ivsc-firmware
  ];
}
