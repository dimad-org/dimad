FCOMP = gfortran
FCFLAGS = -g -std=legacy
LDFLAGS = -lm -dynamic
PROGRAM = dimad
SRCS = dimad.f
OBJECTS = $(SRCS:.f=.o)

ifeq ($(UNAME), Darwin)
SDKROOT="$(xcrun --show-sdk-path)"
MACOSX_DEPLOYMENT_TARGET ?= 11.0
export MACOSX_DEPLOYMENT_TARGET
export SDKROOT
endif

all: $(PROGRAM)
.PHONY: all

$(PROGRAM): $(OBJECTS)
	$(FCOMP) $(FCFLAGS) -o $@ $^ $(LDFLAGS)

%.o: %.f
	$(FCOMP) $(FCFLAGS) -c $<

test:
	bash run-tests.sh
.PHONY: test

clean:
	rm -f *.o $(PROGRAM)
.PHONY: clean
