
==================================================
GeoJSON Extension for the MapSetJSON Specification
==================================================

Authors
  Trey Smith (Carnegie Mellon University)

Revision
  Pre-0.1 draft

Date
  20 Jan 2012

Canonical URL of this document
  http://mapmixer.org/mapsetjson/ext/geojson/0.1/

Further information
  http://mapmixer.org/mapsetjson/

.. contents::
   :depth: 2

.. sectnum::

Introduction
============

This extension adds GeoJSON support to the `MapSetJSON Core Specification`_.

.. _MapSetJSON Core Specification: http://mapmixer.org/mapsetjson/spec/0.1/


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

GeoJSON Node Type
=================

A GeoJSON node ("type": "geojson.GeoJSON") declares a map layer that links to GeoJSON
content:

 * The behavior of the GeoJSON node is modeled on the behavior of the
   `MapSetJSON Link Node Type`_.

 * A GeoJSON node must have a member "url", whose value is a string
   specifying the URL of the GeoJSON document. This extension does not
   define the behavior if the URL has a fragment identifier starting
   with a hash mark #.

 * This extension does not define any introspection capabilities within
   GeoJSON documents.

 * This extension does not define how GeoJSON map content should be
   styled in the map. Note that there are existing implementations of
   default styling, such as the `OpenLayers GeoJSON
   implementation`_. Future versions of this extension may define a
   styling mechanism.

 * Unless the GeoJSON node is initially visible, loading of the subdocument
   must be postponed until the user turns on the link's visibility.

 * When a GeoJSON node becomes visible, the viewer must load the subdocument
   and render its contents in the map.

.. _MapSetJSON Link Node Type: http://mapmixer.org/mapsetjson/spec/0.1/#link-node-type
.. _OpenLayers GeoJSON implementation: http://openlayers.org/dev/examples/vector-formats.html
