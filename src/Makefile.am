SUBDIRS = lib

bin_PROGRAMS = pmgap_cmplx2repn

# LDADD = ./lib/libpmgap.la

pmgap_cmplx2repn_SOURCES = pmgap_cmplx2repn.cpp
pmgap_cmplx2repn_LDADD = ./lib/libpmgap.la

gapscriptsdir = @gapscriptsdir@
gapscripts_DATA = loader.g

PYSCRPT = pmgap_from_homcloud_random_cech.py
GPSCRPTIN = pmgap_interval_decomposable.in pmgap_batch_interval_decomposable.in pmgap_generate_intervals.in
GPSCRPTOUT = $(GPSCRPTIN:.in=.sh)

EXTRA_DIST = loader.g $(PYSCRPT) $(GPSCRPTIN)
bin_SCRIPTS = $(PYSCRPT) $(GPSCRPTOUT)
CLEANFILES = $(GPSCRPTOUT)

$(GPSCRPTOUT): %.sh: %.in
	$(SED) \
		-e 's|[@]gapscriptsdir@|$(gapscriptsdir)|g' \
		-e 's|[@]prefix@|$(prefix)|g' \
		-e 's|[@]exec_prefix@|$(exec_prefix)|g' \
		-e 's|[@]bindir@|$(bindir)|g' \
		-e 's|[@]datarootdir@|$(datarootdir)|g' \
		< "$<" > "$@"
