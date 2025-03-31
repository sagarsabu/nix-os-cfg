{ ... }:
{
  security = {
    # tpm2
    tpm2 = {
      enable = true;
      applyUdevRules = true;
      # pkcs11.enable = true;
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
}
