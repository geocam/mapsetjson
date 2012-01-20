
==================================================
Refresh Extension for the MapSetJSON Specification
==================================================

Authors
  Trey Smith (Carnegie Mellon University)

Revision
  Pre-0.1 draft

Date
  20 Jan 2012

Canonical URL of this document
  http://mapmixer.org/mapsetjson/ext/refresh/0.1/

Further information
  http://mapmixer.org/mapsetjson/

.. contents::
   :depth: 2

.. sectnum::

Introduction
============

This extension adds the ability to specify refresh rates for map layers.
It extends the `MapSetJSON Core Specification`_.

.. _MapSetJSON Core Specification: http://mapmixer.org/mapsetjson/spec/0.1/


Examples
========

To declare that a MapSetJSON document uses this extension::

  "extensions": {
    "refresh": "http://mapmixer.org/mapsetjson/ext/refresh/0.1/"
  }

An example link node that will be refreshed every 60 seconds::

  {
    "type": "Link",
    "name": "Subfolder Managed by External Organization",
    "url": "http://example.com/externalLayers.json",
    "refresh.mode": "onInterval",
    "refresh.interval": 60
  }

Refresh Members
===============

This extensions defines new members for link nodes (see `Link Node
Type`_) and extension types that model their behavior on link nodes (see
`KML Node Type`_, `GeoJSON Node Type`_). These types are called
"extended types" in the discussion below. To "refresh" means to fetch
the linked content of the node again and update the map display with any
changes.

MapSetJSON refresh behavior is modeled on the `KML Link tag`_.

 * Extended types may have a member "refresh.mode", whose value is a string,
   which can be one of the following:

   * "onChange" (default): Refresh only when the node parameters change.

   * "onInterval": Refresh every `n` seconds (specified in
     "refresh.interval").
   
   * "onExpire": Refresh when the expiration time is reached, as specified
     by the HTTP ``max-age`` or ``Expires`` mechanisms (see
     `HTTP Header Field Definitions`_).

 * Extended types may have a member "refresh.interval", whose value is a
   number, indicating to refresh every `n` seconds.
   
 * Extended types may have a member "refresh.viewMode", whose value is a
   string specifying how map view changes affect refresh. The value can
   be one of the following [#viewModeNever]_:

   * "onRequest" (default): Refresh only when the user explicitly
     requests it.

   * "onStop": Refresh `n` seconds after the view stops moving,
     where `n` is specified in "refresh.viewTime".

 * Extended types may have a member "refresh.viewTime", whose value is a number,
   indicating to refresh `n` seconds after the view stops moving.

 * Extended types may have a member "refresh.viewFormat", whose value is
   a string that specifies the format of a query string to append to
   the node's URL before sending to the server. No query string is
   appended by default. The format may include template parameters drawn
   from the following:

   * ``[bboxWest]``, ``[bboxSouth]``, ``[bboxEast]``, ``[bboxNorth]``:
     Boundaries of the minimum-size geospatial bounding box that
     includes the current map view, scaled by the
     "refresh.viewBoundScale" member if provided.

 * Extended types may have a member "refresh.viewBoundScale", whose
   value is a number which scales the bounding box parameters before
   sending them to the server. A value less than 1 specifies to use less
   than the full view (screen). A value greater than 1 specifies to
   fetch an area that extends beyond the edges of the current view.

 * Extended types may have a member "refresh.httpQuery", whose value
   is a string that specifies the format of a query string to append
   to the node's URL before sending to the server. No query string is
   appended by default. The format may include template parameters drawn
   from the following:

   * ``[viewerName]``: The name of the viewer. For a JavaScript web
     browser based viewer implementation, this should ordinarily be the
     name of the viewer implementation itself, not (for example) the
     name of the browser, which is already passed to the server in an
     HTTP header.

   * ``[viewerVersion]``: The version of the viewer.

   * ``[mapsetjsonVersion]``: The value of the "mapsetjson" member of
     the primary MapSetJSON document.

   * ``[language]``: The user's preferred language, specified according
     to `IETF BCP 47`_.

.. _Link Node Type: http://mapmixer.org/mapsetjson/spec/0.1/#link-node-type
.. _KML Node Type: http://mapmixer.org/mapsetjson/ext/kml/0.1/#kml-node-type
.. _GeoJSON Node Type: http://mapmixer.org/mapsetjson/ext/geojson/0.1/#geojson-node-type
.. _KML Link tag: http://code.google.com/apis/kml/documentation/kmlreference.html#link
.. _HTTP Header Field Definitions: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html
.. _IETF BCP 47: http://www.rfc-editor.org/rfc/bcp/bcp47.txt

Footnotes
=========

.. [#viewModeNever] KML defines additional <viewRefreshMode> values of
   "onRegion" and "never".  This extension does not define "onRegion"
   because MapSetJSON lacks any equivalent to the KML <Region>. It does
   not define "never" because, in practice, Google Earth treats "never"
   the same as "onRequest".
