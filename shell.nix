{ pkgs ? (import <nixpkgs> {}) }:

with pkgs;
let
  mpi = mpich;
  mumps = callPackage ./mumps {};
  petsc = callPackage ./petsc {
    inherit mumps sowing mpi;
  };
  slepc = callPackage ./slepc { inherit petsc; };
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
        openblas
        petsc
        slepc
        openmpi
      ];
    };

in
sparselizard
