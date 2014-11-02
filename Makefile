BINDIR := $(HOME)/bin

# END OF USER CONFIG

bins := $(wildcard bin/*)

install:
	mkdir -p $(BINDIR)
	cp $(bins) $(BINDIR) 

.PHONY: install
