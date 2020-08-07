SUBDIRS = lib

bin_PROGRAMS = helloworld

LD_ADD = ./lib/libpmgap.la

helloworld_SOURCES = helloworld.cpp
helloworld_LDFLAGS = ./lib/libpmgap.la -lgyoza
