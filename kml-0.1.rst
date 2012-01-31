
==============================================
KML Extension for the MapSetJSON Specification
==============================================

Authors
  Trey Smith (Carnegie Mellon University)

Revision
  Pre-0.1 draft

Date
  31 Jan 2012

Canonical URL of this document
  http://mapmixer.org/mapsetjson/ext/kml/0.1/

Further information
  http://mapmixer.org/mapsetjson/

.. contents::
   :depth: 2

.. sectnum::

Introduction
============

This extension adds the ability to include KML map layers in a map set.
It extends the `MapSetJSON Core Specification`_.

This specification refers to the `MapSetJSON Folder Extension`_ and the
`MapSetJSON Include Extension`_.

.. _MapSetJSON Core Specification: http://mapmixer.org/mapsetjson/spec/0.1/
.. _MapSetJSON Folder Extension: http://mapmixer.org/mapsetjson/ext/folder/0.1/
.. _MapSetJSON Include Extension: http://mapmixer.org/mapsetjson/ext/include/0.1/

Examples
========

To declare that a MapSetJSON document uses this extension::

  "extensions": {
    "kml": "http://mapmixer.org/mapsetjson/ext/kml/0.1/"
  }

An example KML node::

  {
    "type": "kml.KML",
    "name": "Earthquake Intensity",
    "url": "http://mapmixer.org/mapsetjson/example/eqintensity.kml"
  }

Definitions
===========

The KML file format is defined by the `KML OGC Standard`_. The `KML
Developer Reference`_ is also useful.

.. _KML OGC Standard: http://www.opengeospatial.org/standards/kml
.. _KML Developer Reference: http://code.google.com/apis/kml/documentation/kmlreference.html

KML Class
=========

A KML object (``"type": "kml.KML"``) declares a map layer that links to KML
content.

The behavior of KML objects is modeled on the behavior of Include
objects as specified in the `MapSetJSON Include Extension`_. The KML
subdocument is loaded in the same way as a MapSetJSON subdocument, and
displayed similarly in the layer selection interface. When the KML
object is visible, the appearance of the KML content in the map is
defined by the `KML OGC Standard`_.

We use the following rules to identify corresponding features of KML and
MapSetJSON documents:

 * By default, the included node is the top-level tag of the KML
   subdocument. However, if the ``url`` member of the KML object
   contains a fragment identifier starting with a hash mark ``#``, the
   fragment must match the ``id`` attribute of a tag in the KML
   document, and that tag is the included node.

 * For the purposes of controlling the layer selection interface, the
   following equivalencies hold between MapSetJSON members and KML
   members:

   * MapSetJSON ``open`` = KML ``<open>``. Corresponding values:
     ``true`` = ``1``, ``false`` = ``0``.

   * MapSetJSON ``visibilityControl`` = KML ``<listItemStyle>``.

 * Some viewer implementations may be able to display KML content
   without being able to introspect its internal structure in the layer
   selection interface. These implementations should document that they
   "implement the KML extension without introspection support".

Abstract class:
  No

Inherits from:
  Layer, folder.FolderLike

(No additional members defined.)

KML Example
~~~~~~~~~~~

::

  {
    // members inherited from Object
    "type": "kml.KML",
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
    "url": "http://example.com/layer.kml#optionalIdOfTagInKMLDocument",

    // members inherited from folder.FolderLike
    "open": false,
    "visibilityControl": "check"
  }
