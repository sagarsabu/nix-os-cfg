{
  pkgs,
  inputs,
  system,
  ...
}:
{
  imports = [
    inputs.distro-grub-themes.nixosModules.${system}.default
  ];

  # aka 6.15.2
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    # fix hangs with PSR
    "amdgpu.dcdebugmask=0x600"
  ];

  boot = {
    tmp = {
      useTmpfs = true;
      tmpfsSize = "100%";
    };
    # Bootloader.
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "nodev";
        useOSProber = true;
        efiSupport = true;
        fontSize = 20;
      };
    };
  };

  distro-grub-themes = {
    enable = true;
    theme = "nixos";
  };
}
