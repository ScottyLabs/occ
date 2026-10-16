{
  flake.modules.nixos.sops =
    { pkgs, ... }:
    {
      sops = {
        age = {
          # tpm-sealed identity from age-plugin-tpm --generate
          keyFile = "/var/lib/sops-nix/key.txt";
          plugins = [ pkgs.age-plugin-tpm ];
          sshKeyPaths = [ ];
        };
        gnupg.sshKeyPaths = [ ];
      };
    };
}
