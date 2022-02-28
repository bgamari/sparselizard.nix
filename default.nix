{ pkgs ? (import (import nix/sources.nix).nixpkgs {}) }:

with pkgs;
let
  things = rec {
    inherit pkgs;
    inherit (pkgs) gmsh paraview;

    mpi = openmpi;
    blas = openblasCompat;

    mumps = callPackage ./mumps { inherit blas; };
    petsc = callPackage ./petsc {
      inherit mumps sowing mpi blas;
    };
    slepc = callPackage ./slepc { inherit mpi petsc blas; };
    sowing = callPackage ./sowing { };
    scalapack = pkgs.scalapack.override { inherit mpi; };

    sparselizard = callPackage ./sparselizard {
      inherit petsc blas slepc openmpi mumps;
    };
  };

in
things
