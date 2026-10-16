{
  flake.modules.nixos.base =
    { lib, ... }:
    {
      users.users.root.openssh.authorizedKeys.keyFiles = lib.filter (
        file: baseNameOf file == "ssh.pub"
      ) (lib.filesystem.listFilesRecursive ../../keys/admins);
    };
}
