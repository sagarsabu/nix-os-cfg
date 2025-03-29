{ pkgs, inputs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  users.defaultUserShell = pkgs.fish;
  users.users.sagar = {
    isNormalUser = true;
    description = "sagar";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
      "nordvpn"
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
}
