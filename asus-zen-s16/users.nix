{ pkgs, inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  users.defaultUserShell = pkgs.fish;
  users.users = {
    sagar = {
      isNormalUser = true;
      group = "sagar";
      description = "Sagar";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "nordvpn"
        "wireshark"
      ];
      packages = with pkgs; [
        # themes and icons
        sweet
        candy-icons
        bibata-cursors
      ];
    };

  };
  users.groups = {
    sagar = {
      name = "sagar";
    };
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs pkgs; };
    backupFileExtension = "backup";
    users = {
      sagar = import ./home.nix;
    };
  };
}
