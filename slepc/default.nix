{ stdenv, python3, gfortran, git, mpi,
  petsc, blas, liblapack }:

stdenv.mkDerivation {
  name = "slepc";
  nativeBuildInputs = [ python3 gfortran git ];
  buildInputs = [ mpi petsc blas liblapack ];
  src = fetchTarball {
    url = "https://slepc.upv.es/download/distrib/slepc-3.16.2.tar.gz";
    sha256 = "sha256:1iavw9iad8cknxf7dhkacf9z63bgd2sx87hx2l2r5zkrz0md9hjx";
  };
  PETSC_DIR = petsc;
  preConfigure = ''
    patchShebangs .
  '';
  configurePhase = ''
    export SLEPC_DIR="`pwd`"
    python3 ./config/configure.py --prefix=$out
  '';
}
