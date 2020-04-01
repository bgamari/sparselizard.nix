{ pkgs ? (import <nixpkgs> {}) }:

with pkgs;
let
  mumps = callPackage ./mumps {};
  petsc = callPackage ./petsc { inherit mumps; };

  sparselizard = 
    stdenv.mkDerivation {
      name = "sparselizard";
      INCL = "-I${petsc}/include/petsc/mpiuni";
      LIBS = "";
      buildInputs = [
        gnumake
        gcc
        gfortran
        openblas
        petsc
        openmpi
      ];
    };

in
sparselizard
