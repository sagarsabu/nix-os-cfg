# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  inputs,
  config,
  pkgs,
  system,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
  };

  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./audio.nix
    ./security.nix
    ./il18.nix
    ./global-programs.nix
    inputs.home-manager.nixosModules.home-manager
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

  networking.hostName = "sagar-zen-s16-laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager = {
    enable = true;
    wifi = {
      powersave = false;
      backend = "iwd";
    };
  };

  # Set your time zone.
  time.timeZone = "Pacific/Auckland";

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
  # Force radv
  environment.variables.AMD_VULKAN_ICD = "RADV";

  # enable firmware update daemon
  services.fwupd.enable = true;

  # Enable the X11 windowing system.
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
  # services.libinput.enable = true;
  users.defaultUserShell = pkgs.fish;
  users.users.sagar = {
    isNormalUser = true;
    description = "sagar";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = [
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs pkgs; };
    backupFileExtension = "backup";
    users = {
      sagar = import ./home.nix;
    };
  };

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
    ]
    ++ (with pkgs.gnomeExtensions; [
      systemd-status
      dock-from-dash
    ]);

  # docker
  virtualisation.docker = {
    enable = true;
    rootless.enable = true;
    rootless.setSocketVariable = true;
  };

  environment = {
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
  };

  # systemd
  systemd = {
    tpm2.enable = true;
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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
