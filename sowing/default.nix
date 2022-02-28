{ stdenv }:

stdenv.mkDerivation {
  name = "sowing";
  src = fetchGit {
    url = "https://bitbucket.org/petsc/pkg-sowing";
    rev = "c88d03bfe147ba48ba29bde0e6df7de5e21baf9a";
  };
}
