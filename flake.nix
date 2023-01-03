{
  description = "Environment providing the Sparselizard FEM library";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  inputs.nixpkgs.url = "github:bgamari/nixpkgs?ref=wip/gmsh-shared";

  inputs.sparselizard = {
    url = "github:halbux/sparselizard/5d9a70c8394093360d5ef81e7a52061519207305";
    flake = false;
  };

  inputs.solvers-nix = {
    url = "github:bgamari/solvers.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        solvers = inputs.solvers-nix.packages.${system}.openmpi;
      in {
        packages = rec {
          inherit (solvers) mpi blas petsc slepc mumps;

          sparselizard = pkgs.callPackage ./sparselizard {
            inherit mpi petsc blas slepc mumps;
            src = inputs.sparselizard;
          };

          examples = pkgs.callPackage ./sparselizard/examples.nix {
            inherit mpi petsc sparselizard;
            inherit (pkgs) gmsh;
            src = inputs.sparselizard;
          };

          default = sparselizard;
        };
      }
    );
}
