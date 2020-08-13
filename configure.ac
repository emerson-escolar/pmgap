AC_INIT([pmgap], [package])
AM_INIT_AUTOMAKE([foreign -Wall -Werror])

AC_PROG_LN_S
AM_PROG_AR
LT_INIT

AC_LANG([C++])
AC_PROG_CXX

AC_CONFIG_MACRO_DIR([m4])
m4_include([m4/find_gap.m4])
FIND_GAP

# Checks for header files.
AC_HEADER_DIRENT
AC_HEADER_STDC
AC_HEADER_SYS_WAIT


AC_CHECK_HEADERS([Eigen/Core], [], [AC_MSG_ERROR([eigen not found])])
AC_CHECK_HEADERS([gyoza/gyoza.h], [], [AC_MSG_ERROR([gyoza not found])])
AC_CHECK_HEADERS([nlohmann/json.hpp], [], [AC_MSG_ERROR([nlohmann/json.hpp not found])])

AC_CHECK_HEADERS([catch.hpp], [], [AC_MSG_ERROR([catch not found])])



AC_CONFIG_FILES([Makefile])
AC_CONFIG_FILES([src/Makefile])
AC_CONFIG_FILES([tst/Makefile])

AC_CONFIG_FILES([src/lib/Makefile])

AC_OUTPUT
