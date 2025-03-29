{ ... }:
{
  # globally configured programs

  programs.firefox.enable = true;
  programs.xwayland.enable = true;
  programs.nix-ld.enable = true;

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  # fish
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable greeting
    '';
  };

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
}
