{
  inputs,
  config,
  pkgs,
  system,
  ...
}:
{
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };
  nixpkgs.config.allowUnfree = true;

  # for better shell completions
  documentation.man.generateCaches = true;

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./boot.nix
    ./audio.nix
    ./security.nix
    ./il18.nix
    ./network.nix
    ./time.nix
    ./global-programs.nix
    ./sys-packages.nix
    ./users.nix
    inputs.nur.modules.nixos.default
    inputs.nur.legacyPackages.x86_64-linux.repos.wingej0.modules.nordvpn
  ];

  hardware = {
    enableAllFirmware = true;
    graphics = {
      enable = true;
      extraPackages = [
        pkgs.rocmPackages.clr.icd
        pkgs.amdvlk
        pkgs.libva
      ];
      extraPackages32 = [
        # To enable Vulkan support for 32-bit applications
        pkgs.driversi686Linux.amdvlk
      ];
    };
    amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
      amdvlk.enable = true;
      amdvlk.support32Bit.enable = true;
      amdvlk.supportExperimental.enable = true;
    };
  };

  # enable firmware update daemon
  services.fwupd.enable = true;

  # Install NordVPN
  nixpkgs.overlays = [
    (final: prev: {
      nordvpn = pkgs.nur.repos.wingej0.nordvpn;
    })
  ];
  services.nordvpn.enable = true;

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

  services.gnome.games.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # docker
  virtualisation.docker = {
    enable = true;
    rootless.enable = true;
    rootless.setSocketVariable = true;
  };

  environment = {
    variables = {
      # Force radv
      AMD_VULKAN_ICD = "RADV";
    };
    interactiveShellInit = ''
      alias grep='grep --colour=auto'
    '';
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      XCURSOR_THEME = "Bibata-Original-Classic";
    };
    gnome.excludePackages = (
      with pkgs;
      [
        gnome-console
      ]
    );
    # for better bash completions
    pathsToLink = [
      "/share/bash"
      "/share/fish"
    ];
  };

  # systemd
  systemd = {
    tpm2.enable = true;

    # first stall on login
    services."getty@tty1".enable = false;
    services."autovt@tty1".enable = false;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
