SUBDIRS = lib

bin_PROGRAMS = helloworld cmplx2repn

# LDADD = ./lib/libpmgap.la

helloworld_SOURCES = helloworld.cpp
helloworld_LDADD = ./lib/libpmgap.la

cmplx2repn_SOURCES = cmplx2repn.cpp
cmplx2repn_LDADD = ./lib/libpmgap.la


gapscriptsdir = @gapscriptsdir@
gapscripts_DATA = loader.g

EXTRA_DIST = loader.g pmgap_interval_decomposable.in

bin_SCRIPTS = pmgap_interval_decomposable.sh
CLEANFILES = pmgap_interval_decomposable.sh

pmgap_interval_decomposable.sh:	pmgap_interval_decomposable.in
	$(SED) \
		-e 's|[@]gapscriptsdir@|$(gapscriptsdir)|g' \
		-e 's|[@]prefix@|$(prefix)|g' \
		-e 's|[@]exec_prefix@|$(exec_prefix)|g' \
		-e 's|[@]bindir@|$(bindir)|g' \
		-e 's|[@]datarootdir@|$(datarootdir)|g' \
		< "$<" > "$@"
