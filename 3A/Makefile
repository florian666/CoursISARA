#!/usr/bin/make -f

 NAMEFILE := $(basename $(shell find -name "*.md" -printf "%P\n"))

 P := pandoc
 RM := rm -f

# rules
all: $(patsubst %, %.pdf, $(NAMEFILE))

%.pdf: %.md
	$(P) -o $@ $<

clean:
	$(RM) $(patsubst %, %.pdf, $(NAMEFILE))

re : clean all

# phony
.PHONY: all clean re
