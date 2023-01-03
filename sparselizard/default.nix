{ stdenv, src, cmake, python3, gfortran, git,
  petsc, blas, slepc, mpi, mumps, metis }:

stdenv.mkDerivation {
  name = "sparselizard";
  nativeBuildInputs = [ cmake ];
  buildInputs = [
    blas
    petsc
    slepc
    mpi
    mumps
  ];
  inherit src;
  INCL = "-I${petsc}/include/petsc/mpiuni";
  #LIBS = "-lopenblas -lpetsc -lslepc -lmpi";
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

