{ pkgs ? (import <nixpkgs> {}) }:

with pkgs;
let
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

in
sparselizard
