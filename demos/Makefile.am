
GPSCRPT =	pmgap_demo_interval_approximation.g

GPSCRPTIN =
GPSCRPTOUT = $(GPSCRPTIN:.in=.sh)

EXTRA_DIST = $(gapscripts_DATA) $(GPSCRPTIN) $(GPSCRPT)
CLEANFILES = $(GPSCRPTOUT)

$(GPSCRPTOUT): %.sh: %.in
	$(SED) \
		-e 's|[@]gapscriptsdir@|$(gapscriptsdir)|g' \
		-e 's|[@]prefix@|$(prefix)|g' \
		-e 's|[@]exec_prefix@|$(exec_prefix)|g' \
		-e 's|[@]bindir@|$(bindir)|g' \
		-e 's|[@]datarootdir@|$(datarootdir)|g' \
		< "$<" > "$@"
