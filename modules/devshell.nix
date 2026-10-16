{ lib, ... }:
let
  ageKeys =
    dir:
    map (file: lib.trim (builtins.readFile file)) (
      lib.filter (file: baseNameOf file == "age.pub") (lib.filesystem.listFilesRecursive dir)
    );
  rule = path: keys: {
    path_regex = "(^|/)secrets/${path}";
    age = lib.concatStringsSep "," keys;
  };
in
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
        SOPS_CONFIG = (pkgs.formats.yaml { }).generate "sops.yaml" {
          creation_rules =
            # a host's own secrets file is readable by that host and admins only
            map (host: rule "hosts/${host}\\.yaml$" (ageKeys ../keys/admins ++ ageKeys ../keys/hosts/${host})) (
              lib.attrNames (builtins.readDir ../keys/hosts)
            )
            ++ [ (rule "" (ageKeys ../keys)) ];
        };
      };
    };
}
