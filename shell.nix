{ pkgs ? (import <nixpkgs> {}) }:

with pkgs;
let
  mpi = mpich;
  blas = openblasCompat;

  mumps = callPackage ./mumps { inherit blas; };
  petsc = callPackage ./petsc {
    inherit mumps sowing mpi blas;
  };
  slepc = callPackage ./slepc { inherit petsc blas; };
  sowing = callPackage ./sowing { };
  scalapack = pkgs.scalapack.override { inherit mpi; };

  sparselizard = 
    stdenv.mkDerivation {
      name = "sparselizard";
      INCL = "-I${petsc}/include/petsc/mpiuni";
      LIBS = "-lopenblas -lpetsc -lslepc";
      buildInputs = [
        gnumake
        gcc
        gfortran
        blas
        petsc
        slepc
        openmpi
      ];
    };

in
sparselizard
