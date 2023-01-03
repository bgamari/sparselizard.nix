{ stdenv, lib, src, petsc, mpi, gmsh, sparselizard }:

let
  mkExample = { name, extraCFlags ? "" }: 
    let drv =
      stdenv.mkDerivation {
        name = "sparselizard-example-${name}";
        buildInputs = [
          sparselizard petsc mpi gmsh
        ];
        inherit src;
        buildPhase = ''
          cd examples
          g++ -I${sparselizard}/include/sparselizard -lsparselizard -o ${name}/main ${name}/main.cpp ${extraCFlags}
        '';
        installPhase = ''
          mkdir -p $out
          cp -R ${name}/* $out
        '';
      };
    in lib.nameValuePair name drv;

in
  lib.listToAttrs
  [
    (mkExample {
      name = "thermoacoustic-elasticity-axisymmetry-2d";
    })
    (mkExample {
      name = "nonlinear-vonkarman-vortex-2d";
    })
  ]
