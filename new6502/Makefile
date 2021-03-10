# Copyright (C) 2021 Morten Jagd Christensen, LICENSE: BSD2
#

include makefiles/Makefile.macros

MODULES = cpu decode
CFLAGS.cpu = -Gmemory_file='"test/cpumemory_test.data"'
UNITS =
UNITS.dspmod =


TARGETS = $(addsuffix Test, $(addprefix bin/, $(MODULES))) $(addsuffix Test, $(addprefix bin/, $(UNITS)))
COVTARGETS = $(addsuffix .dat, $(addprefix logs/, $(MODULES)))

vpath %.sv src/modules src/units

all: directories $(TARGETS)
	@echo "done"

# Create dependencies using macros
# main targets
$(foreach module, $(MODULES), $(eval $(call make_bintargets,$(module))))
$(foreach unit, $(UNITS), $(eval $(call make_bintargets,$(unit))))
# dependencies
$(foreach module, $(MODULES), $(eval $(call make_mktargets,$(module),modules,,$(CFLAGS.$(module)))))
$(foreach unit, $(UNITS), $(eval $(call make_mktargets,$(unit),units,$(UNITS.$(unit)))))


include makefiles/Makefile.test

# make sure build directory is created
.PHONY: directories
#
directories: build bin

build:
	@mkdir -p build bin logs

# Misc clean targets
clean:
	@rm -fr build bin logs *.bak

realclean: clean
	@rm -fr googletest db output_files simulation
