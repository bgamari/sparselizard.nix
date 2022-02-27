{ stdenv, pkgconfig, gfortran, blas, liblapack, python, mpi,
  metis, mumps, scotch, scalapack, sowing }:

stdenv.mkDerivation rec {
  name = "petsc";
  version = "3.16.3";
  src = fetchTarball {
    url = "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-${version}.tar.gz";
    sha256 = "sha256:0yplx2hfp7glm5jhckam0gnhfznhki6ki318b59pzmx7pyvvaz6j";
  };

  nativeBuildInputs = [
    pkgconfig gfortran python
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

  configurePhase = ''
    python configure --prefix=$out $configureFlags
    '';

  installPhase = ''
    make install
  '';
}

