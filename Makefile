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

.PHONY: release release-patch release-minor release-major

EDITOR ?= vim
VERSION = $(shell node -pe 'require("./package.json").version')
release-patch: NEXT_VERSION = $(shell node -pe 'require("semver").inc("$(VERSION)", "patch")')
release-minor: NEXT_VERSION = $(shell node -pe 'require("semver").inc("$(VERSION)", "minor")')
release-major: NEXT_VERSION = $(shell node -pe 'require("semver").inc("$(VERSION)", "major")')
release-patch: release
release-minor: release
release-major: release

release: all
	node -e '\
		var j = require("./package.json");\
		j.version = "$(NEXT_VERSION)";\
		var s = JSON.stringify(j, null, 2);\
		require("fs").writeFileSync("./package.json", s);'
	git commit package.json -m 'Version $(NEXT_VERSION)'
	git tag -a "v$(NEXT_VERSION)" -m "Version $(NEXT_VERSION)"
	git push --tags origin HEAD:master
	npm publish
