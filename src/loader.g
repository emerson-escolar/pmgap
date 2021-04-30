LoadPackage("pmgap");;
# force gap to quit with error state on error.
OnBreak := function() Where(); QUIT_GAP(1); end;;
LOADER_DEFINED := true;;
