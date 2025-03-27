# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  unstable-nix = import <unstable-nix> { config.allowUnfree = true; };
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # aka 6.14
  boot.kernelPackages = pkgs.linuxPackages_testing;
  boot.kernelParams = [
    # fix hangs with PSR
    "amdgpu.dcdebugmask=0x600"
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "sagar-zen-s16-laptop"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Pacific/Auckland";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_NZ.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_NZ.UTF-8";
    LC_IDENTIFICATION = "en_NZ.UTF-8";
    LC_MEASUREMENT = "en_NZ.UTF-8";
    LC_MONETARY = "en_NZ.UTF-8";
    LC_NAME = "en_NZ.UTF-8";
    LC_NUMERIC = "en_NZ.UTF-8";
    LC_PAPER = "en_NZ.UTF-8";
    LC_TELEPHONE = "en_NZ.UTF-8";
    LC_TIME = "en_NZ.UTF-8";
  };

  hardware.graphics = {
    enable = true;
    # vulkan
    extraPackages = [
      pkgs.amdvlk
      # To enable Vulkan support for 32-bit applications
      pkgs.driversi686Linux.amdvlk
    ];
  };
  # Force radv
  environment.variables.AMD_VULKAN_ICD = "RADV";

  # enable firmware update daemon
  services.fwupd.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    autorun = true;
    enable = true;
    videoDrivers = [ "amdgpu" ];
    # Enable the GNOME Desktop Environment.
    displayManager.gdm.enable = true;
    displayManager.gdm.wayland = true;
    desktopManager.gnome.enable = true;
    # Configure keymap in X11
    xkb = {
      layout = "nz";
      variant = "";
    };
  };

  services.gnome.games.enable = false;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;

    pulse.enable = true;

    # try fix sub-wuffer
    # from "https://github.com/BNieuwenhuizen/zenbook-s16"

    extraConfig.pipewire-pulse = {
      "99-speaker-routing" = {
        "context.modules" = [
          {
            "name" = "libpipewire-module-loopback";
            "args" = {
              "node.description" = "Stereo to 4.0 upmix";
              "audio.position" = [
                "FL"
                "FR"
              ];
              "capture.props" = {
                "node.name" = "sink.upmix_4_0";
                "media.class" = "Audio/Sink";
              };
              "playback.props" = {
                "node.name" = "playback.upmix-4.0";
                "audio.position" = [
                  "FL"
                  "FR"
                  "RL"
                  "RR"
                ];
                "target.object" = "alsa_output.pci-0000_c4_00.6.analog-surround-40";
                "stream.dont-remix" = true;
                "node.passive" = true;
                "channelmix.upmix" = true;
                "channelmix.upmix-method" = "simple";
              };
            };
          }
        ];
      };
    };

    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sagar = {
    isNormalUser = true;
    description = "sagar";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
    packages = with pkgs; [ ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
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
    # unstable pkgs aka bleeding edge
    unstable-nix.vscode
    unstable-nix.google-chrome
  ];

  # docker
  virtualisation.docker = {
    enable = true;
    rootless.enable = true;
    rootless.setSocketVariable = true;
  };

  # globally configured programs
  programs.firefox.enable = true;
  programs.nix-ld.enable = true;
  programs.git.enable = true;
  programs.git.lfs.enable = true;
  # programs.xwayland.enable = true;

  # htop
  programs.htop = {
    enable = true;
    settings = {
      hide_kernel_threads = true;
    };
  };

  # neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # systemd
  systemd = {
    tpm2.enable = true;
  };

  # security
  security = {

    # tpm2
    tpm2 = {
      enable = true;
      applyUdevRules = true;
      pkcs11.enable = true;
      abrmd.enable = true;
    };

    # passwordless root access
    sudo.extraRules = [
      {
        users = [ "sagar" ];
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];

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
