FCOMP = gfortran
FCFLAGS = -g -O2 -std=legacy -Wl,-L/Library/Developer/CommandLineTools/SDKs/MacOSX14.sdk/usr/lib/ -Wl,-L$(CONDA_PREFIX)/lib -lgfortran
# LDFLAGS = -lm -L
PROGRAM = dimad
SRCS = dimad.f
OBJECTS = $(SRCS:.f=.o)
MACOSX_DEPLOYMENT_TARGET=14.0

export MACOSX_DEPLOYMENT_TARGET

all: $(PROGRAM)

$(PROGRAM): $(OBJECTS)
	$(FCOMP) $(FCFLAGS) -o $@ $^ $(LDFLAGS)

%.o: %.f
	$(FCOMP) $(FCFLAGS) -c $<

.PHONY: clean veryclean

clean:
	rm -f *.o *.mod *.MOD $(PROGRAM)
