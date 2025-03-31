{ pkgs, ... }:
{

  # for NordVPN
  nixpkgs.overlays = [
    (final: prev: {
      nordvpn = pkgs.nur.repos.wingej0.nordvpn;
    })
  ];

  # enable firmware update daemon
  services.fwupd.enable = true;

  services.nordvpn.enable = true;

  services.resolved.enable = true;

  # enable display managers.
  # NOTE: this is not necessarily related to XServer / X11 / Xorg
  services.xserver = {
    enable = true;
    videoDrivers = [ "amdgpu" ];
    # Option "TearFree" "true"
    # Enable the GNOME Desktop Environment.
    displayManager.gdm = {
      enable = true;
      wayland = true;
    };
    desktopManager.gnome = {
      enable = true;
    };
    # Configure keymap in X11
    xkb = {
      layout = "nz";
      variant = "";
    };
  };

  services.flatpak.enable = true;

  services.gnome.games.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;
}
