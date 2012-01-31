
==================================================
Refresh Extension for the MapSetJSON Specification
==================================================

Authors
  Trey Smith (Carnegie Mellon University)

Revision
  Pre-0.1 draft

Date
  31 Jan 2012

Canonical URL of this document
  http://mapmixer.org/mapsetjson/ext/refresh/0.1/

Further information
  http://mapmixer.org/mapsetjson/

.. contents::
   :depth: 2

.. sectnum::

Introduction
============

This extension adds the ability to specify when map layers should be
refreshed.  It extends the `MapSetJSON Core Specification`_.

.. _MapSetJSON Core Specification: http://mapmixer.org/mapsetjson/spec/0.1/


Examples
========

To declare that a MapSetJSON document uses this extension::

  "extensions": {
    "refresh": "http://mapmixer.org/mapsetjson/ext/refresh/0.1/"
  }

An example Include object that will be refreshed every 60 seconds::

  {
    "type": "include.Include",
    "name": "Subfolder Managed by External Organization",
    "url": "http://example.com/externalLayers.json",
    "refresh.mode": "onInterval",
    "refresh.interval": 60
  }

Refresh Members
===============

This extension defines new members for classes of nodes that link to
external content through a ``url`` member, including the Layer class and
the Include class of the `MapSetJSON Include Extension`_. These members
specify when and how to refresh the node.

To "refresh" means to fetch the linked content of the node again and
update the map display with any changes.

.. _MapSetJSON Include Extension: http://mapmixer.org/mapsetjson/ext/include/0.1/

+---------------------------+-----------+-------------------+------------------------------------+
|Member                     |Type       |Values             |Meaning                             |
+===========================+===========+===================+====================================+
|``refresh.mode``           |enumerated |``"onChange"``     |Refresh when the node's parameters  |
|                           |(string)   |(default)          |change.                             |
|                           |           +-------------------+------------------------------------+
|                           |           |``"onInterval"``   |Refresh every `n` seconds (specified|
|                           |           |                   |in ``refresh.interval``).           |
|                           |           +-------------------+------------------------------------+
|                           |           |``"onExpire"``     |Refresh when the expiration time is |
|                           |           |                   |reached, as specified by the HTTP   |
|                           |           |                   |``max-age`` or ``Expires``          |
|                           |           |                   |mechanisms (see `HTTP Header Field  |
|                           |           |                   |Definitions`_).                     |
+---------------------------+-----------+-------------------+------------------------------------+
|``refresh.interval``       |number     |optional           |Number of seconds to wait between   |
|                           |           |                   |refreshes in ``"onInterval"`` mode. |
+---------------------------+-----------+-------------------+------------------------------------+
|``refresh.viewMode``       |enumerated |``"onRequest"``    |Refresh when the user explicitly    |
|[#viewModeNever]_          |(string)   |(default)          |requests it.                        |
|                           |           +-------------------+------------------------------------+
|                           |           |``"onStop"``       |Refresh `n` seconds after the view  |
|                           |           |                   |stops moving (specified in          |
|                           |           |                   |``refresh.viewTime``).              |
+---------------------------+-----------+-------------------+------------------------------------+
|``refresh.viewTime``       |number     |optional (default: |Number of seconds to wait after view|
|                           |           |``0``)             |stops moving in ``"onStop"`` mode.  |
+---------------------------+-----------+-------------------+------------------------------------+
|``refresh.viewFormat``     |string     |optional           |The format of a query string to     |
|                           |           |                   |append to the ``url`` member before |
|                           |           |                   |sending to the server. No query     |
|                           |           |                   |string is appended by default. See  |
|                           |           |                   |`Refresh viewFormat Template        |
|                           |           |                   |Parameters`_.                       |
+---------------------------+-----------+-------------------+------------------------------------+
|``refresh.viewBoundScale`` |number     |optional           |How much to scale the map view      |
|                           |           |                   |bounding box before filling in      |
|                           |           |                   |[bbox...]  template parameters for  |
|                           |           |                   |``refresh.viewFormat``. An amount   |
|                           |           |                   |less than 1 means the bounding box  |
|                           |           |                   |includes a subset of the map        |
|                           |           |                   |view. An amount greater than 1 means|
|                           |           |                   |it includes additional area around  |
|                           |           |                   |the map view.                       |
+---------------------------+-----------+-------------------+------------------------------------+
|``refresh.httpQuery``      |string     |optional           |The format of a query string to     |
|                           |           |                   |append to the ``url`` member before |
|                           |           |                   |sending to the server. No query     |
|                           |           |                   |string is appended by default. See  |
|                           |           |                   |`Refresh httpQuery Template         |
|                           |           |                   |Parameters`_.                       |
+---------------------------+-----------+-------------------+------------------------------------+

.. Refresh viewFormat Template Parameters:

Refresh viewFormat Template Parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``refresh.viewFormat`` string may include template parameters drawn
from the following:

 * ``[bboxWest]``, ``[bboxSouth]``, ``[bboxEast]``, ``[bboxNorth]``:
   These are the boundaries of the minimum-size geospatial bounding box
   that includes the current map view, scaled by the
   ``refresh.viewBoundScale`` member if provided.

.. Refresh httpQuery Template Parameters:

Refresh httpQuery Template Parameters
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The ``refresh.httpQuery`` string may include template parameters drawn
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

.. _KML Node Type: http://mapmixer.org/mapsetjson/ext/kml/0.1/#kml-node-type
.. _GeoJSON Node Type: http://mapmixer.org/mapsetjson/ext/geojson/0.1/#geojson-node-type
.. _KML Link tag: http://code.google.com/apis/kml/documentation/kmlreference.html#link
.. _HTTP Header Field Definitions: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html
.. _IETF BCP 47: http://www.rfc-editor.org/rfc/bcp/bcp47.txt

Refresh Example
~~~~~~~~~~~~~~~

::

  {
    "type": "kml.KML",
    "name": "Fire Vehicle Locations",
    "url": "http://example.com/fireVehicleLocations.kml",

    // basic refresh options: refresh every 60 seconds
    "refresh.mode": "onInterval",
    "refresh.interval": 60,

    // view-based refresh options: also refresh every time the user
    // moves the map view (but wait to send the request until 5 seconds
    // after the view stops moving)
    "refresh.viewMode": "onStop",
    "refresh.viewTime": 5,

    // pass view information to server as query parameters
    "refresh.viewFormat": "bbox=[bboxWest],[bboxSouth],[bboxEast],[bboxNorth]",

    // make the viewFormat bbox parameters include 10% extra padding around
    // the map view
    "refresh.viewBoundScale": 1.1,

    // pass other information to server as query parameters
    "refresh.httpQuery": "viewer=[viewerName]&version=[viewerVersion]&lang=[language]"
  }

Footnotes
=========

.. [#viewModeNever] KML defines additional <viewRefreshMode> values of
   "onRegion" and "never".  This extension does not define "onRegion"
   because MapSetJSON lacks any equivalent to the KML <Region>. It does
   not define "never" because, in practice, Google Earth treats "never"
   the same as "onRequest".
