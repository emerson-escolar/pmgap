noinst_LTLIBRARIES = libgridbirthtype.la libgridcomplex.la libslicedhomology.la libpmgap.la

AM_CPPFLAGS=-I$(top_srcdir)/src/lib

libgridbirthtype_la_SOURCES = gridbirthtype.cpp
libgridcomplex_la_SOURCES = gridcomplex.cpp
libslicedhomology_la_SOURCES = slicedhomology.cpp

libpmgap_la_SOURCES =
libpmgap_la_LIBADD = libgridbirthtype.la libgridcomplex.la libslicedhomology.la
libpmgap_la_LDFLAGS =

# for Tests

check_PROGRAMS = test_all

test_all_SOURCES = test_all.cpp \
test_slicedhomology.cpp \
test_gridcomplex.cpp \
test_gridbirthtype.cpp \
test_gridslice.cpp

test_all_CPPFLAGS =
test_all_LDADD = libpmgap.la -lgyoza

TESTS = $(check_PROGRAMS)
