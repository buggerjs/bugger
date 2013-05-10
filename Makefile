default: all

SRC = $(shell find src -name "*.coffee" -type f | sort)
LIB = $(SRC:src/%.coffee=lib/%.js)

COFFEE = node_modules/.bin/coffee --js --bare
MOCHA  = node_modules/.bin/mocha --timeout 3s --recursive --compilers coffee:coffee-script-redux -u tdd
WACHS  = node_modules/.bin/wachs
GROC   = node_modules/.bin/groc

all: build

build: $(LIB)

watch:
	$(WACHS) -o "src/**/*.coffee" make all

docs:
	$(GROC) "src/**/*.coffee" README.md

clean:
	@rm $(LIB)

lib/%.js: src/%.coffee
	@echo "[coffee] "$<
	dirname "$@" | xargs mkdir -p
	@$(COFFEE) -i "$<" >"$(@:%=%.tmp)" && mv "$(@:%=%.tmp)" "$@"

.PHONY : test
test: build
	NODE_ENV=test ${MOCHA} -R spec -r test/setup.js --recursive test
