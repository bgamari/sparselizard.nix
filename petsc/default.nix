{ stdenv, pkgconfig, gfortran, blas, liblapack, python, mpi,
  metis, mumps, scotch, scalapack, sowing }:

stdenv.mkDerivation {
  name = "petsc";
  src = fetchGit {
    url = "https://github.com/petsc/petsc";
    rev = "33f32bedbeeda898f7c48846933db3cc6191ec7e";
  };

  nativeBuildInputs = [
    pkgconfig gfortran
  ];
  buildInputs = [
    blas liblapack python mumps scalapack sowing mpi
  ];
  enableParallelBuilding = true;

  patches = [ ./fix-petsc-configure.patch ];

  preConfigure = ''
    patchShebangs .
    configureFlagsArray=(
      $configureFlagsArray
      --prefix=$out
    )
  '';

  PETSC_ARCH = "arch-linux2-c-opt";

  configureFlags = [
    "--with-fc=gfortran"
    "--with-openmp"
    "--with-mpi=0"
    #"--with-ptscotch"
    #"--with-ptscotch-dir=${scotch}"
    "--with-metis"
    "--with-metis-dir=${metis}"
    "--with-mumps-serial"
    "--with-mumps-dir=${mumps}"
    #"--with-scalapack"
    "--with-shared-libraries=1"
    "--with-scalar-type=real"
    "--with-debugging=0"
    "--with-blas-lib=[${blas}/lib/libblas.a,${gfortran.cc.lib}/lib/libgfortran.a]"
    "--with-lapack-lib=[${liblapack}/lib/liblapack.a,${gfortran.cc.lib}/lib/libgfortran.a]"
    "COPTFLAGS=-O3"
    "CXXOPTFLAGS=-O3"
    "FOPTFLAGS=-O3"
  ];

  installPhase = ''
    make install
  '';
}

