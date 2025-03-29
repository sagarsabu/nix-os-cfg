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

  # aka 6.14
  boot.kernelPackages = pkgs.linuxPackages_testing;
  boot.kernelParams = [
    # fix hangs with PSR
    "amdgpu.dcdebugmask=0x600"
  ];

  # Bootloader.
  boot.loader = {
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

  distro-grub-themes = {
    enable = true;
    theme = "nixos";
  };
}
