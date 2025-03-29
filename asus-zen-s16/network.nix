{ ... }:
{
  # Enable networking
  networking = {
    hostName = "sagar-zen-s16-laptop";
    # wireless.enable = true;  # Enables wireless support via wpa_supplicant.
    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    networkmanager = {
      enable = true;
      wifi = {
        powersave = false;
        backend = "iwd";
      };
    };

    # Open ports in the firewall.
    # for nordvpn
    # https://github.com/nix-community/nur-combined/blob/main/repos/wingej0/README.md
    wireguard.enable = true;
    firewall.checkReversePath = false;
    # firewall.allowedTCPPorts = [ ];
    # firewall.allowedUDPPorts = [ ];

    # Or disable the firewall altogether.
    # firewall.enable = false;
  };
}
