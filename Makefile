default: all

SRC = $(shell find src -name "*.coffee" -type f | sort)
LIB = $(SRC:src/%.coffee=lib/%.js)

COFFEE = node_modules/.bin/coffee --js --bare
WACHS  = node_modules/.bin/wachs
GROC   = node_modules/.bin/groc

all: compile

compile: lib_dirs $(LIB)

watch:
	$(WACHS) -o "src/**/*.coffee" make all

docs:
	$(GROC) "src/**/*.coffee" README.md

clean:
	@rm $(LIB)

lib:
	@test -d lib || mkdir lib

lib_dirs: lib/inspector lib/forked lib/lang

lib/%.js: src/%.coffee
	@echo "[coffee] "$<
	@$(COFFEE) -i "$<" >"$(@:%=%.tmp)" && mv "$(@:%=%.tmp)" "$@"

lib/%: lib
	@test -d "$@" || mkdir "$@"
