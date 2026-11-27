# a list of all the programs in your project
PROGS = main

# a list of all your units to be linked with your programs (space separated)
OTHERS =

#------------ CAPD configuration ------------------------------
# Do not edit paths here. Put them in config.mk (see config.mk.example)
# or pass them on the command line: make CAPD_CONFIG=/path/to/capd-config
-include config.mk

# by default, look for capd-config in PATH
CAPD_CONFIG ?= capd-config

CAPDCXX = $(shell $(CAPD_CONFIG) --variable=capd_cxx)
CAPDFLAGS = $(shell $(CAPD_CONFIG) --cflags)
CAPDLIBS = $(shell $(CAPD_CONFIG) --libs)

# stop early with a readable message (not needed for `make clean`)
ifneq ($(MAKECMDGOALS),clean)
ifeq ($(strip $(CAPDCXX)),)
$(error Cannot run '$(CAPD_CONFIG)'. Copy config.mk.example to config.mk and set CAPD_CONFIG.)
endif
endif

# EXTRA_* are empty unless set in config.mk
CXXFLAGS = $(EXTRA_ARCH) $(EXTRA_CXXFLAGS) $(CAPDFLAGS)
CXXFLAGS += -Wno-deprecated-literal-operator

# directory where object and dependancy files will be created
OBJDIR = .obj/

#============ the following should not be changed =========

OTHERS_OBJ = ${OTHERS:%=${OBJDIR}%.o}
OBJ_FILES = ${OTHERS_OBJ} ${PROGS:%=${OBJDIR}%.o}

.PHONY: all
all: ${PROGS}

# set log color
LOG_COLOR=\033[38;5;245m
LOG_NO_COLOR=\033[0m

# rule to link executables
${PROGS}: % : ${OBJDIR}%.o ${OTHERS_OBJ}
		@printf "${LOG_COLOR}Linking${LOG_NO_COLOR}\n"
		@${CAPDCXX} ${EXTRA_ARCH} -o $@ $< ${OTHERS_OBJ} ${EXTRA_LDFLAGS} ${CAPDLIBS}
		@printf "${LOG_COLOR}Finished${LOG_NO_COLOR}\n"

# include files with dependencies
-include ${OBJ_FILES:%=%.d}

#rule to compile .cpp files and generate corresponding files with dependencies
${OBJ_FILES}: ${OBJDIR}%.o : src/%.cpp
		@mkdir -p ${OBJDIR}
		@printf "${LOG_COLOR}Compiling${LOG_NO_COLOR}\n"
		@$(CAPDCXX) ${CXXFLAGS} -MT $@ -MD -MP -MF ${@:%=%.d} -c -o $@ $<

# rule to clean all object files, dependencies and executables
.PHONY: clean
clean:
		@rm -f ${OBJDIR}*.o ${OBJDIR}*.o.d ${PROGS}
		@printf "${LOG_COLOR}Cleaned${LOG_NO_COLOR}\n"
