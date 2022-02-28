{ stdenv, cmake, python3, gfortran, git,
  petsc, blas, slepc, openmpi, mumps, metis }:

stdenv.mkDerivation {
  name = "sparselizard";
  nativeBuildInputs = [ cmake ];
  buildInputs = [
    blas
    petsc
    slepc
    openmpi
    mumps
  ];
  INCL = "-I${petsc}/include/petsc/mpiuni";
  #LIBS = "-lopenblas -lpetsc -lslepc -lmpi";
  src = (import ../nix/sources.nix).sparselizard;
  cmakeFlags = [
    "-DPETSC_PATH=${petsc}"
    "-DPETSCCONF_INCLUDE_PATH=${petsc}/include"
    "-DPETSC_LIBRARIES=${petsc}/lib/libpetsc.so"
    "-DSLEPC_INCLUDE_PATH=${slepc}/include"
    "-DSLEPC_LIBRARIES=${slepc}/lib/libslepc.so"
    "-DMUMPS_INCLUDE_PATH=${mumps}/include"
    "-DMUMPS_LIBRARIES=${mumps}/lib/libcmumps.a"
    "-DBLAS_INCLUDE_PATH=${blas}/include"
    "-DBLAS_LIBRARIES=${blas}/lib/libblas.so"
    "-DMETIS_INCLUDE_PATH=${metis}/include"
    "-DMETIS_LIBRARIES=${metis}/lib/libmetis.a"
  ];
}

