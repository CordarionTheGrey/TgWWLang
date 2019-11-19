.PHONY: all README.md

# https://nedbatchelder.com/code/cog/
COG := cog
COG_FLAGS := -e

all: README.md

README.md:
	@$(COG) $(COG_FLAGS) -cr $@
