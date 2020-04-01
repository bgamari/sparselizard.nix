{ stdenv, metis, parmetis, scotch, openblas, gfortran }:

stdenv.mkDerivation {
  name = "mumps";
  src = fetchGit {
    url = "https://bitbucket.org/petsc/pkg-mumps";
    rev = "d1a5c931b762d0da8183dea55b69f7fd59e00a48";
  };

  nativeBuildInputs = [ gfortran ];
  propagatedBuildInputs = [ metis parmetis openblas ];

  MAKE_INC = ''
    LPORDDIR = $(topdir)/PORD/lib/
    IPORD    = -I$(topdir)/PORD/include/
    LPORD    = -L$(LPORDDIR) -lpord

    LMETISDIR = ${metis}/lib
    IMETIS    = -I${metis}/include/metis

    ORDERINGSF = -Dmetis -Dpord
    ORDERINGSC  = $(ORDERINGSF)

    LORDERINGS = $(LMETIS) $(LPORD) $(LSCOTCH)
    IORDERINGSF = $(ISCOTCH)
    IORDERINGSC = $(IMETIS) $(IPORD) $(ISCOTCH)

    PLAT    =
    LIBEXT  = .a
    OUTC    = -o 
    OUTF    = -o 
    RM = /bin/rm -f
    CC = gcc
    FC = gfortran
    FL = gfortran
    AR = ar vr 
    RANLIB = ranlib
    LAPACK = -llapack

    INCSEQ = -I$(topdir)/libseq
    LIBSEQ  = $(LAPACK) -L$(topdir)/libseq -lmpiseq

    LIBBLAS = -lblas
    LIBOTHERS = -lpthread

    CDEFS   = -DAdd_

    OPTF    = -O -fopenmp
    OPTL    = -O -fopenmp
    OPTC    = -O -fopenmp
     
    INCS = $(INCSEQ)
    LIBS = $(LIBSEQ)
    LIBSEQNEEDED = libseqneeded
  '';
  enableParallelBuilding = true;
  configurePhase = ''
    echo "$MAKE_INC" > Makefile.inc
  '';
  buildFlags = "alllib";
  installPhase = ''
    ls -R .
    mkdir -p $out/lib
    cp libseq/libmpiseq.a $out/lib
    cp lib/*.a $out/lib
    cp -r include $out/include
  '';
}

