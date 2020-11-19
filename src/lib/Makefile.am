noinst_LTLIBRARIES = libgridbirthtype.la libgridcomplex.la libslicedhomology.la libpmgap.la libz2matrix.la libsetchain.la

AM_CPPFLAGS=-I$(top_srcdir)/src/lib

libgridbirthtype_la_SOURCES = gridbirthtype.cpp
libgridcomplex_la_SOURCES = gridcomplex.cpp
libslicedhomology_la_SOURCES = slicedhomology.cpp


libz2matrix_la_SOURCES = z2.cpp z2matrix.cpp
libsetchain_la_SOURCES = setchain.cpp


libpmgap_la_SOURCES =
libpmgap_la_LIBADD = libgridbirthtype.la libgridcomplex.la libslicedhomology.la libz2matrix.la libsetchain.la
libpmgap_la_LDFLAGS =

# for Tests

check_PROGRAMS = test_all

test_all_SOURCES = test_all.cpp \
test_slicedhomology.cpp \
test_gridcomplex.cpp \
test_gridbirthtype.cpp \
test_gridslice.cpp \
test_z2.cpp \
test_z2matrix.cpp \
test_setchain.cpp

test_all_CPPFLAGS =
test_all_LDADD = libpmgap.la

TESTS = $(check_PROGRAMS)
