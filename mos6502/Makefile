# Copyright (C) 2021 Morten Jagd Christensen, LICENSE: BSD2
#

.DEFAULT_GOAL:= all

define my_test
build/$(1)/$(1): build/$(1)
	@make -C build/$(1) -j 8 -f $(1).mk
endef


MODULES = cpumemory instreg memmux control pcounter alu
#MODULES = alu
COMMONMOD = src/common_types.sv

EXTRA_FLAGS_cpumemory := -Gmemory_file='"test/cpumemory_test.data"'


# Generate rules to make the test executable
$(foreach mymod, $(MODULES), $(eval $(call my_test,$(mymod))))

TARGETS = $(join $(addsuffix /, $(addprefix build/, $(MODULES))), $(MODULES))

all: directories $(TARGETS) #build/top/top
	@echo "done"

# build/top/top: build/top
# 	@make -C build/top -j 8 -f top.mk

build/%: src/%.sv $(COMMONMOD)
	@verilator -Wall -cc $(COMMONMOD) $<  -y . -Mdir $@ --prefix $(notdir $@) \
            --exe ../../test/$(notdir $@)_test.cpp \
            -LDFLAGS "-L../../googletest/build/lib -lgtest -lpthread" \
            -CFLAGS "-std=c++11" \
            -CFLAGS "-I../../googletest/googletest/include/" $(EXTRA_FLAGS_$(notdir $@))

RUNTARGETS = $(TARGETS) #build/top/top

runtest: $(RUNTARGETS)
	for test in $(RUNTARGETS); do ./$$test || exit 1; done

# build/top: src/common_types.sv src/control.sv src/memmux.sv src/top.sv
# 	mkdir -p build
# 	@verilator -Wall -cc $^  -y . -Mdir build/top --prefix top \
#             --exe ../../test/top_test.cpp \
#             -LDFLAGS "-L../../googletest/build/lib -lgtest -lpthread" \
#             -CFLAGS "-std=c++11" \
#             -CFLAGS "-I../../googletest/googletest/include/" $(EXTRA_FLAGS_$(notdir $@))

gtest:
	./scripts/makegtest


# make sure build directory is built
.PHONY: directories

directories: build

build:
	@mkdir -p build

# Misc clean targets
clean:
	@rm -fr build *.bak

realclean: clean
	@rm -fr googletest db output_files simulation
