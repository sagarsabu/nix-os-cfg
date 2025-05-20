{ pkgs, ... }:
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    with pkgs;
    [
      man-pages
      man-pages-posix
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
      vlc
      transmission_4-qt
      htop

      # for openvpn
      lz4

      # build tools
      gcc14
      gdb
      gnumake42
      cmake
      cmake-format
      cppcheck
      llvmPackages_19.clang-tools
      rustup
      cargo-binstall

      # languages
      dotnetCorePackages.dotnet_9.sdk
      python313Full
      nodejs_20

      # libraries
    ]
    ++ (with pkgs.gnomeExtensions; [
      systemd-status
      dock-from-dash
    ]);
}
