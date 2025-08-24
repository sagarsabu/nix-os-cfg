{ ... }:
{
  # globally configured programs
  programs = {
    firefox.enable = true;
    xwayland.enable = true;
    nix-ld.enable = true;

    git = {
      enable = true;
      lfs.enable = true;
    };

    # fish
    fish = {
      enable = true;
      interactiveShellInit = ''
        # Disable greeting
        set fish_greeting
        # enable work bash aliases
        source /home/sagar/.work_bash_aliases.fish
      '';
    };

    # neovim
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };

    openvpn3.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    };

    # wireshark
    wireshark = {
      enable = true;
      dumpcap.enable = true;
    };

    appimage = {
      enable = true;
      binfmt = true;
    };
  };
}
