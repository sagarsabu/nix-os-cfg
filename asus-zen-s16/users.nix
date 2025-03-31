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
      description = "The local user";
      extraGroups = [
        "networkmanager"
        "wheel"
        "docker"
        "nordvpn"
      ];
      packages = [
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
