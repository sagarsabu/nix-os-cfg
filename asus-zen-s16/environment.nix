{ pkgs, ... }:
{
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
}
