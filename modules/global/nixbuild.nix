let
  hostName = "eu.nixbuild.net";
in
{
  flake.modules.nixos.nixbuild =
    { config, ... }:
    {
      sops.secrets.nixbuild-ssh-key.sopsFile = ../../secrets/nixbuild.yaml;

      nix = {
        distributedBuilds = true;
        buildMachines = [
          {
            inherit hostName;
            protocol = "ssh-ng";
            system = "x86_64-linux";
            maxJobs = 100;
            supportedFeatures = [
              "benchmark"
              "big-parallel"
              "ca-derivations"
              "kvm"
              "nixos-test"
              "uid-range"
            ];
          }
          {
            inherit hostName;
            protocol = "ssh-ng";
            system = "aarch64-linux";
            maxJobs = 100;
            supportedFeatures = [
              "benchmark"
              "big-parallel"
              "ca-derivations"
              "nixos-test"
              "uid-range"
            ];
          }
        ];
        settings.builders-use-substitutes = true;
      };

      programs.ssh = {
        knownHosts.nixbuild = {
          hostNames = [ hostName ];
          publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPIQCZc54poJ8vqawd8TraNryQeJnvH1eLpIDgbiqymM";
        };
        extraConfig = ''
          Host ${hostName}
            ServerAliveInterval 60
            IdentityFile ${config.sops.secrets.nixbuild-ssh-key.path}
        '';
      };
    };
}
