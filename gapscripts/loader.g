# Copied from gyoza:
# https://bitbucket.org/remere/gyoza/src/master/
# GPL3

LoadPackage("qpa");;
# force gap to quit with error state on error.
OnBreak := function() Where(); QUIT_GAP(1); end;;
LOADER_DEFINED := true;;
