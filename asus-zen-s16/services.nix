{ pkgs, ... }:
{

  # for NordVPN
  nixpkgs.overlays = [
    (final: prev: {
      nordvpn = pkgs.nur.repos.wingej0.nordvpn;
    })
  ];

  services = {
    # enable firmware update daemon
    fwupd.enable = true;
    nordvpn.enable = true;
    # resolved.enable = true;

    # enable display managers.
    # NOTE: this is not necessarily related to XServer / X11 / Xorg
    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];
      # Configure keymap in X11
      xkb = {
        layout = "nz";
        variant = "";
      };
    };
    # Option "TearFree" "true"
    # Enable the GNOME Desktop Environment.
    desktopManager.gnome = {
      enable = true;
    };
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };

    flatpak.enable = true;
    gnome.games.enable = false;

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;
  };

}
