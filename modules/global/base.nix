let
  cluster = import ../../cluster.nix;
in
{
  flake.modules.nixos.base =
    { config, lib, ... }:
    let
      host = cluster.hosts.${config.networking.hostName};
    in
    {
      users.users.root.openssh.authorizedKeys.keyFiles = lib.filter (file: baseNameOf file == "ssh.pub") (
        lib.filesystem.listFilesRecursive ../../keys/admins
      );

      nix = {
        inherit (host.nix) settings;
        daemonCPUSchedPolicy = "batch";
        daemonIOSchedClass = "idle";
      };

      # root's nix over ssh would otherwise build outside the daemon's memory cap
      environment.sessionVariables.NIX_REMOTE = "daemon";
      systemd.services.nix-daemon.serviceConfig.MemoryMax = host.buildMemoryMax;
    };
}
