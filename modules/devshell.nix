{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        packages = [
          pkgs.age
          pkgs.sops
          pkgs.zensical
        ];
      };
    };
}
