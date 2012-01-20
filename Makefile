
RST2HTML=rst2html.py --stylesheet=spec.css

all: \
  build/spec/0.1/index.html \
  build/ext/registry/index.html \
  build/ext/kml/0.1/index.html \
  build/ext/geojson/0.1/index.html \
  build/ext/refresh/0.1/index.html

clean:
	rm -rf build

publish: all
	rsync -rvz build/ mapmixer.org:/var/www-mapmixer.org/mapsetjson

build/spec/0.1/index.html: mapsetjson-0.1.rst spec.css
	[ -d build/spec/0.1/ ] || mkdir -p build/spec/0.1/
	$(RST2HTML) $< $@

build/ext/registry/index.html: registry.rst spec.css
	[ -d build/ext/registry/ ] || mkdir -p build/ext/registry/
	$(RST2HTML) $< $@

build/ext/kml/0.1/index.html: kml-0.1.rst spec.css
	[ -d build/ext/kml/0.1/ ] || mkdir -p build/ext/kml/0.1/
	$(RST2HTML) $< $@

build/ext/geojson/0.1/index.html: geojson-0.1.rst spec.css
	[ -d build/ext/geojson/0.1/ ] || mkdir -p build/ext/geojson/0.1/
	$(RST2HTML) $< $@

build/ext/refresh/0.1/index.html: refresh-0.1.rst spec.css
	[ -d build/ext/refresh/0.1/ ] || mkdir -p build/ext/refresh/0.1/
	$(RST2HTML) $< $@
