{ stdenv, python3, gfortran, git,
  petsc, blas, liblapack }:

stdenv.mkDerivation {
  name = "slepc";
  nativeBuildInputs = [ python3 gfortran git ];
  buildInputs = [ petsc blas liblapack ];
  src = fetchGit {
    url = "https://gitlab.com/slepc/slepc.git";
    rev = "c7de62a5856282e1a558370d350270cbcf4fa572";
  };
  PETSC_DIR = petsc;
  preConfigure = ''
    patchShebangs .
  '';
}
