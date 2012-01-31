
==================================================
GeoJSON Extension for the MapSetJSON Specification
==================================================

Authors
  Trey Smith (Carnegie Mellon University)

Revision
  Pre-0.1 draft

Date
  31 Jan 2012

Canonical URL of this document
  http://mapmixer.org/mapsetjson/ext/geojson/0.1/

Further information
  http://mapmixer.org/mapsetjson/

.. contents::
   :depth: 2

.. sectnum::

Introduction
============

This extension adds the ability to include GeoJSON map layers in a map set.
It extends the `MapSetJSON Core Specification`_.

This specification refers to the `MapSetJSON Include Extension`_.

.. _MapSetJSON Core Specification: http://mapmixer.org/mapsetjson/spec/0.1/
.. _MapSetJSON Include Extension: http://mapmixer.org/mapsetjson/ext/include/0.1/

Examples
========

To declare that a MapSetJSON document uses this extension::

  "extensions": {
    "geojson": "http://mapmixer.org/mapsetjson/ext/geojson/0.1/"
  }

An example GeoJSON node::

  {
    "type": "geojson.GeoJSON",
    "name": "Fire Vehicle Locations",
    "url": "http://mapmixer.org/mapsetjson/example/vehicles.json"
  }

Definitions
===========

The GeoJSON file format is defined by the `GeoJSON Format Specification`_.

.. _GeoJSON Format Specification: http://geojson.org/geojson-spec.html

GeoJSON Class
=============

A GeoJSON object (``"type": "geojson.GeoJSON"``) declares a map layer that
links to GeoJSON content. The behavior of the GeoJSON object is modeled on
the behavior of the `MapSetJSON Include Extension`_. The GeoJSON
subdocument is loaded in the same way as a MapSetJSON subdocument.

The GeoJSON Format Specification does not define how GeoJSON content should
be styled in a map. Viewers may implement any appropriate styling, and may
wish to draw their default styling from a reference implementation such as
the `OpenLayers GeoJSON implementation`_.

 * Future versions of this extension may define the behavior if the
   ``url`` member has a fragment identifier starting with a hash mark
   ``#``.

 * Future versions of this extension may define introspection
   capabilities within GeoJSON documents.

 * Future versions of this extension may define a styling mechanism.

Abstract class:
  No

Inherits from:
  Layer

(No additional members defined.)

.. _MapSetJSON Include Extension: http://mapmixer.org/mapsetjson/ext/include/0.1/
.. _OpenLayers GeoJSON implementation: http://openlayers.org/dev/examples/vector-formats.html

GeoJSON Example
~~~~~~~~~~~~~~~

::

  {
    // members inherited from Object
    "type": "geojson.GeoJSON",
    "id": "...",

    // members inherited from Node
    "name": "...",
    "crs": { (CRS object ) },
    "bbox": [
      [-180.0, -90.0],
      [180.0, 90.0]
    ],
    "description": "...",
    "subject": [
      "(Key word 1)",
      ...
    ],
    "coverage": "(Human readable description of temporal or spatial coverage)",
    "creator": "(Name of entity)",
    "contributors": [
      "(Name of entity 1)",
      ...
    ],
    "publisher": "(Name of entity)",
    "rights": "Copyright (C) ...",
    "license": "http://creativecommons.org/licenses/ ...",
    "morePermissions": "You may also ...",
    "dateCreated": "2012-01-30T12:00:00Z",
    "dateModified": "2012-01-30T12:00:00Z",
    "dateAdded": "2012-01-30T12:00:00Z",

    // members inherited from Layer
    "show": false,
    "drawOrder": 1000,
    "master": false,
    "url": "http://example.com/layer.json",

    // members inherited from folder.FolderLike
    "open": false,
    "visibilityControl": "check"
  }
