{
  description = "Open Compute Cluster";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    srvos.url = "github:nix-community/srvos";
    srvos.inputs.nixpkgs.follows = "nixpkgs";

    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    scottylabs.url = "git+https://git.cmu.dev/ScottyLabs/kennel";
    scottylabs.inputs.nixpkgs.follows = "nixpkgs";

    # Flake infrastructure
    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-parts.flakeModules.modules
        (inputs.import-tree ./modules)
      ];

      systems = [
        "aarch64-linux"
        "x86_64-linux"
      ];

      perSystem =
        { pkgs, ... }:
        {
          packages.docs = (inputs.scottylabs.mkLib pkgs).buildZensical {
            src = ./sites/docs;
            name = "occ-docs";
          };
        };
    };
}
