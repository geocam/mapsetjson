
RST2HTML=rst2html.py --stylesheet=spec.css

all: build/mapsetjson.html

build:
	mkdir -p build

build/mapsetjson.html: mapsetjson.rst spec.css
	[ -d build ] || mkdir -p build
	$(RST2HTML) $< $@
