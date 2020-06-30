LoadPackage("pmgap");

TestDirectory(DirectoriesPackageLibrary("pmgap", "tst"),
              rec(exitGap := true));
FORCE_QUIT_GAP(1);
