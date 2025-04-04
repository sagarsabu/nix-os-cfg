{ pkgs, ... }:
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    with pkgs;
    [
      wget
      curl
      tree
      bat
      nixfmt-rfc-style
      wezterm
      pciutils
      lshw
      nix-ld
      mesa
      vulkan-tools
      pulseaudioFull
      pavucontrol
      docker
      nvtopPackages.amd
      home-manager
      gnome-tweaks
      gnome-firmware
      gnome-shell-extensions
      gnome-secrets

      # openvpn
      lz4

      # build tools
      gnumake42
      cmake
      gcc14
      rustup
      cargo-binstall
    ]
    ++ (with pkgs.gnomeExtensions; [
      systemd-status
      dock-from-dash
    ]);
}
