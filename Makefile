default: all

SRC = $(shell find src -name "*.coffee" -type f | sort)
LIB = $(SRC:src/%.coffee=lib/%.js)

COFFEE = node_modules/.bin/coffee --js --bare
MOCHA  = node_modules/.bin/mocha --timeout 3s --recursive --compilers coffee:coffee-script-redux/register -u tdd
WACHS  = wachs
GROC   = node_modules/.bin/groc

all: build

build: $(LIB)

watch:
	$(WACHS) -o "src/**/*.coffee" make all

docs:
	$(GROC) "src/**/*.coffee" README.md

clean:
	@rm $(LIB)

src/inspector.json:
	curl http://trac.webkit.org/browser/trunk/Source/WebCore/inspector/Inspector.json\?format=txt >$@

lib/%.js: src/%.coffee
	@echo "[coffee] "$<
	@dirname "$@" | xargs mkdir -p
	@$(COFFEE) -i "$<" >"$(@:%=%.tmp)" && mv "$(@:%=%.tmp)" "$@"

.PHONY : test test-unit test-functional
test: test-unit test-functional
test-unit: build
	NODE_ENV=test ${MOCHA} -R spec --recursive test/unit
test-functional: build
	NODE_ENV=test ${MOCHA} -R spec --recursive test/functional

.PHONY: release
release:
	git push --tags origin HEAD:master
	npm publish
