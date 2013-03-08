default: all

SRC = $(shell find src -name "*.coffee" -type f | sort)
LIB = $(SRC:src/%.coffee=%.js)

COFFEE = node_modules/.bin/coffee --js --bare

all: $(LIB)

clean:
	@rm $(LIB)

%.js: src/%.coffee
	$(COFFEE) -i "$<" >"$(@:%=%.tmp)" && mv "$(@:%=%.tmp)" "$@"

forked/%.js: src/forked/%.coffee
	$(COFFEE) -i "$<" >"$(@:%=%.tmp)" && mv "$(@:%=%.tmp)" "$@"

inspector/%.js: src/inspector/%.coffee
	$(COFFEE) -i "$<" >"$(@:%=%.tmp)" && mv "$(@:%=%.tmp)" "$@"
