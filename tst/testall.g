LoadPackage("pmgap");

TestDirectory(DirectoriesPackageLibrary("pmgap", "tst"),
              rec(exitGap := true,
                  testOptions := rec(compareFunction :=
                                    "uptowhitespace")));
FORCE_QUIT_GAP(1);
