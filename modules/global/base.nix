let
  cluster = import ../../cluster.nix;
in
{
  flake.modules.nixos.base =
    {
      users.users.root.openssh.authorizedKeys.keys = cluster.adminKeys;
    };
}
