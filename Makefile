default: all

SRC = $(shell find src -name "*.coffee" -type f | sort)
LIB = $(SRC:src/%.coffee=lib/%.js)

COFFEE = node_modules/.bin/coffee --js --bare

all: $(LIB)

clean:
	@rm $(LIB)

lib/%.js: src/%.coffee
	$(COFFEE) -i "$<" >"$(@:%=%.tmp)" && mv "$(@:%=%.tmp)" "$@"

lib/forked/%.js: src/forked/%.coffee
	$(COFFEE) -i "$<" >"$(@:%=%.tmp)" && mv "$(@:%=%.tmp)" "$@"

lib/inspector/%.js: src/inspector/%.coffee
	$(COFFEE) -i "$<" >"$(@:%=%.tmp)" && mv "$(@:%=%.tmp)" "$@"
