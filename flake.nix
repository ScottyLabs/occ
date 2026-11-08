{
  description = "Open Compute Cluster";

  nixConfig = {
    extra-substituters = [ "https://scottylabs.cachix.org" ];
    extra-trusted-public-keys = [
      "scottylabs.cachix.org-1:hajjEX5SLi/Y7yYloiXTt2IOr3towcTGRhMh1vu6Tjg="
    ];
  };

  inputs = {
    scottylabs.url = "git+https://git.cmu.dev/ScottyLabs/kennel";
    nixpkgs.follows = "scottylabs/nixpkgs";
    flake-parts.follows = "scottylabs/flake-parts";

    # the hosts' nixpkgs
    # TODO: https://github.com/NixOS/nixpkgs/pull/575139
    nixpkgs-hosts.url = "github:ap-1/nixpkgs/openfga-26.05";

    srvos.url = "github:nix-community/srvos";
    srvos.inputs.nixpkgs.follows = "nixpkgs-hosts";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs-hosts";

    import-tree.url = "github:vic/import-tree";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.scottylabs.flakeModules.default
        inputs.flake-parts.flakeModules.modules
        (inputs.import-tree ./modules)
      ];

      systems = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
      ];

      perSystem =
        {
          pkgs,
          lib,
          helpers,
          ...
        }:
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
          scottylabs = {
            project.name = "occ";

            shell = {
              packages = [
                pkgs.age
                pkgs.sops
                pkgs.zensical
              ];

              env.SOPS_CONFIG = "${(pkgs.formats.yaml { }).generate "sops.yaml" {
                creation_rules =
                  # a host's own secrets file is readable by that host and admins only
                  map (host: rule "hosts/${host}\\.yaml$" (ageKeys ./keys/admins ++ ageKeys ./keys/hosts/${host})) (
                    lib.attrNames (builtins.readDir ./keys/hosts)
                  )
                  ++ [ (rule "" (ageKeys ./keys)) ];
              }}";
            };
          };

          treefmt.settings.global.excludes = [ "secrets/**" ];

          sites.docs = {
            package = helpers.buildZensical {
              src = ./sites/docs;
              name = "occ-docs";
            };
            customDomain = "docs.occ.build";
          };
        };
    };
}
