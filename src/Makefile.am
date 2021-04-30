SUBDIRS = lib

bin_PROGRAMS = helloworld cmplx2repn

# LDADD = ./lib/libpmgap.la

helloworld_SOURCES = helloworld.cpp
helloworld_LDADD = ./lib/libpmgap.la

cmplx2repn_SOURCES = cmplx2repn.cpp
cmplx2repn_LDADD = ./lib/libpmgap.la


gapscriptsdir = @gapscriptsdir@
gapscripts_DATA = loader.g

EXTRA_DIST = loader.g
