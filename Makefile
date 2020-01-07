.PHONY: all

# https://nedbatchelder.com/code/cog/
COG := cog
COG_FLAGS := -e
README := README.md
JSON_SCHEMA := tgwwlang.schema.json

.PHONY: $(README)

all: $(README) $(JSON_SCHEMA)

$(README):
	@$(COG) $(COG_FLAGS) -cr $@

$(JSON_SCHEMA): tgwwlang.schema.yml
	@echo 'Converting YAML to JSON' && python -c'\
	import json, sys, yaml; \
	json.dump(yaml.safe_load(sys.stdin), sys.stdout, \
		ensure_ascii=False, separators=(",", ":"), sort_keys=True); \
	print("")' <$^ >$@
