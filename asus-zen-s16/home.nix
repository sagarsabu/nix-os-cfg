{
  inputs,
  config,
  pkgs,
  ...
}:
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "sagar";
  home.homeDirectory = "/home/sagar";

  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          user-themes.extensionUuid
          applications-menu.extensionUuid
          system-monitor.extensionUuid
          systemd-status.extensionUuid
          places-status-indicator.extensionUuid
          status-icons.extensionUuid
        ];
      };
    };
  };

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.unstable.vscode
    pkgs.unstable.google-chrome
    pkgs.slack
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".gitconfig".source = ../dotfiles/.gitconfig;
    ".wezterm.lua".source = ../dotfiles/.wezterm.lua;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = { };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
