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

send :
	git add . && git commit -m "1" && git push

SSHeval : 
	ssh-agent -s
	ssh-add
# phony
.PHONY: all clean re
