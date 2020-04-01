{ pkgs ? (import <nixpkgs> {}) }:

with pkgs;
let
  mumps = callPackage ./mumps {};
  petsc = callPackage ./petsc { inherit mumps; };
  slepc = callPackage ./slepc { inherit petsc; };

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
