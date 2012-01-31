
===================================
The MapSetJSON Format Specification
===================================

Authors
  Trey Smith (Carnegie Mellon University)

Revision
  Pre-0.1 draft

Date
  30 Jan 2012

Canonical URL of this document
  http://mapmixer.org/mapsetjson/spec/0.1/

Further information
  http://mapmixer.org/mapsetjson/

.. contents::
   :depth: 2

.. sectnum::

Introduction
============

MapSetJSON is a format for specifying a set of map layers that are
displayed together. MapSetJSON encodes meta-data and links to map
content, not the map content itself. A single map set can link to map
layers in multiple formats and from multiple sources.

MapSetJSON is designed to be viewer-neutral, in that the resulting map
interface can be displayed using a variety of viewers. In practice, we
expect most viewers to be implemented as JavaScript libraries, such that
a MapSetJSON document is loaded by a user's web browser, which then
fetches the linked map content. When used this way, MapSetJSON is also
inherently server-neutral, because the MapSetJSON document can be served
statically to the user without relying on a specialized web mapping
server.

MapSetJSON's primary purpose is to facilitate teams sharing a common map
view to improve their situation awareness. One team member can create a
map set by importing map layers from multiple sources, then share a link
to that map set with the rest of the team. As new information becomes
available, new layers can be rapidly added to the map set, and they will
appear in the common view for all team members. Because it is easy to
customize a map set, even hastily formed teams with minimal
computing expertise can assemble map sets to support their needs.

.. Document Example:

Example
=======

::

  {
    "mapsetjson": "0.1",
    "type": "Document",
    "extensions": {
      "kml": "http://mapmixer.org/mapsetjson/ext/kml/0.1/",
      "geojson": "http://mapmixer.org/mapsetjson/ext/geojson/0.1/"
    },
    "children": [
      {
        "type": "kml.KML",
        "name": "Earthquake Intensity",
        "url": "http://mapmixer.org/mapsetjson/example/eqintensity.kml"
      },
      {
        "type": "geojson.GeoJSON",
        "name": "Fire Vehicle Locations",
        "url": "http://mapmixer.org/mapsetjson/example/vehicles.json"
      }
    ]
  }

Definitions
===========

 * The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
   "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
   document are to be interpreted as described in `IETF RFC 2119`_.

 * JavaScript Object Notation (JSON), and the terms "object", "name", "value",
   "array", and "number", are defined in `IETF RTC 4627`_.  MapSetJSON
   documents have the standard JSON MIME type, "application/json".

 * A "viewer" is a software tool that presents the interactive interface
   specified by a MapSetJSON document to a user.

 * An "interpreter" is a software tool that interprets a MapSetJSON
   document.  An interpreter might be a viewer or any other type of
   tool, such as a validator.

.. _IETF RFC 2119: http://www.ietf.org/rfc/rfc2119.txt
.. _IETF RTC 4627: http://www.ietf.org/rfc/rfc4627.txt

Top-Level Document Structure
============================

A MapSetJSON document consists of a single JSON object which is an
instance of the Document class.  See `Document Class`_.

Classes
=======

MapSetJSON defines classes of objects, following these conventions:

 * An instance of a class is represented as a JSON object.

 * A class instance JSON object must have a "type" field, whose value
   must be a string indicating the name of the class.

 * When we say class B "inherits from" class A, we mean that all of the
   members allowed or required by class A are also allowed or required
   by class B, unless otherwise noted. A is a "parent" or "superclass"
   of B and B is a "subclass" of A.

 * A "concrete" class may be instantiated in a document. An "abstract"
   class is defined solely for use as a superclass of other classes. It
   must not be instantiated in a document.

 * Interpreters should generally ignore members of a class instance JSON
   object that they do not recognize. This allows each interpreter to
   make best effort at processing documents using MapSetJSON extensions
   the interpreter does not support.

This specification defines the following class inheritance hierarchy:

 * Object (abstract)

   * Node (abstract)

     * Collection (abstract)

       * Document

     * Layer (abstract)

   * View (abstract)

     * BoundingBoxView

Additional classes may be defined in MapSetJSON extensions.

Value Types
~~~~~~~~~~~

When stating the value type of class members, we will use standard JSON
types such as ``array`` and ``number``, as well as the following:

+------------+--------------+--------------------------------------------+--------------------------+
|Type        |JSON Type     |Example                                     |Definition                |
+============+==============+============================================+==========================+
|URL         |string        |``"http://example.com/"``                   |A URL, in the             |
|            |              |                                            |standard format           |
|            |              |                                            |defined by `RFC           |
|            |              |                                            |1738`_.                   |
+------------+--------------+--------------------------------------------+--------------------------+
|timestamp   |string        |``"2012-01-30T12:00:00Z"``                  |A timestamp (date         |
|            |              |                                            |and time), in the         |
|            |              |                                            |standard format           |
|            |              |                                            |defined by `ISO           |
|            |              |                                            |8601`_.                   |
+------------+--------------+--------------------------------------------+--------------------------+
|CRS         |object        |                                            |Coordinate reference      |
|            |              |::                                          |system (CRS) object, as   |
|            |              |                                            |defined in the `GeoJSON   |
|            |              | {                                          |CRS specification`_. The  |
|            |              |   "type": "name",                          |default CRS is a          |
|            |              |   "properties": {                          |geographic coordinate     |
|            |              |     "name": "urn:ogc:def:crs:OGC:1.3:CRS84"|reference system, using   |
|            |              |   }                                        |the WGS84 datum, with     |
|            |              | }                                          |longitude and latitude    |
|            |              |                                            |units of decimal degrees. |
+------------+--------------+--------------------------------------------+--------------------------+
|bounding box|array of      |                                            |Geospatial bounding box as|
|            |arrays of     |::                                          |defined by the `GeoJSON   |
|            |numbers       |                                            |bounding box              |
|            |              | [                                          |specification`_.          |
|            |              |   [-180.0, -90.0],                         |                          |
|            |              |   [180.0, 90.0]                            |                          |
|            |              | ]                                          |                          |
+------------+--------------+--------------------------------------------+--------------------------+
|reference   |string        |``"x17"``                                   |A reference is a string   |
|            |              |                                            |that is not intended to be|
|            |              |                                            |meaningful to users and   |
|            |              |                                            |does not need to be       |
|            |              |                                            |translated if the document|
|            |              |                                            |is localized in multiple  |
|            |              |                                            |languages.                |
+------------+--------------+--------------------------------------------+--------------------------+

.. _RFC 1738: http://tools.ietf.org/html/rfc1738
.. _ISO 8601: http://www.w3.org/TR/NOTE-datetime

Object Class
~~~~~~~~~~~~

The Object class is an abstract superclass for all MapSetJSON classes.

Abstract class:
  Yes

Inherits from:
  (none)

+------------------+---------+----------------+------------------------------------+
|Member            |Type     |Values          |Meaning                             |
+==================+=========+================+====================================+
|``type``          |string   |required        |The class of which this object is a |
|                  |         |                |member.                             |
+------------------+---------+----------------+------------------------------------+
|``alternateTypes``|array of |optional        |Fallback options in case the        |
|                  |strings  |                |``type`` class of this object is not|
|                  |         |                |supported by the interpreter (for   |
|                  |         |                |example, the class might be defined |
|                  |         |                |by an experimental MapSetJSON       |
|                  |         |                |extension.)                         |
|                  |         |                |                                    |
|                  |         |                |If it makes sense to interpret the  |
|                  |         |                |object as an instance of more       |
|                  |         |                |commonly supported classes, those   |
|                  |         |                |classes may be specified here in    |
|                  |         |                |preference order.                   |
+------------------+---------+----------------+------------------------------------+
|``id``            |reference|optional        |An identifier that can be used to   |
|                  |         |                |refer to this object. Must be unique|
|                  |         |                |over the scope of a MapSetJSON      |
|                  |         |                |document.                           |
+------------------+---------+----------------+------------------------------------+

Node Class
~~~~~~~~~~

Node objects control content to be rendered in a map and might appear as
entries in the layer selection interface.

Some members of Node are marked below as meta-data [#meta]_. Viewers
should offer users the ability to view a summary of a node's meta-data
members but can otherwise ignore them.

Authors of MapSetJSON documents should avoid defining meta-data members
in cases where they are redundant and likely to cause confusion. For
example, for nodes that link to external content, the "dateModified"
member is redundant with the ``Last-Modified`` HTTP header of the linked
content, and the HTTP header's value is more likely to accurately
reflect the last modification time.

In the discussion below, "resource" can refer to the overall MapSetJSON
document (if the Node is a Document) or content the node links to (if
the Node is a Layer).

Abstract class:
  Yes

Inherits from:
  Object

+-------------------+----------+----------------+------------------------------------+
|Member             |Type      |Values          |Meaning                             |
+===================+==========+================+====================================+
|``name``           |string    |optional        |User-visible name for this node.  If|
|                   |          |                |this node is a Document, the name   |
|                   |          |                |should be used as the document      |
|                   |          |                |title. Otherwise it should be used  |
|                   |          |                |as the node's label in the layer    |
|                   |          |                |selection interface.                |
+-------------------+----------+----------------+------------------------------------+
|``crs``            |CRS       |optional        |Coordinate reference system used to |
|                   |          |(default: WGS84)|interpret coordinates in other      |
|                   |          |                |members of the node.                |
+-------------------+----------+----------------+------------------------------------+
|``bbox``           |bounding  |optional        |Bounding box around the spatial     |
|                   |box       |                |coverage of the resource.           |
+-------------------+----------+----------------+------------------------------------+
|``description``    |string    |optional        |(Meta-data.) Description of the     |
|                   |          |                |resource.                           |
+-------------------+----------+----------------+------------------------------------+
|``subject``        |array of  |optional        |(Meta-data.) Subjects covered by the|
|                   |strings   |                |resource. Subjects might be         |
|                   |          |                |user-defined tags or might be drawn |
|                   |          |                |from a subject thesaurus such as the|
|                   |          |                |`U.S. Library of Congress Subject   |
|                   |          |                |Headings`_.                         |
+-------------------+----------+----------------+------------------------------------+
|``coverage``       |string    |optional        |(Meta-data.) Human-readable         |
|                   |          |                |description of the temporal or      |
|                   |          |                |spatial coverage of the             |
|                   |          |                |resource. (This member is a         |
|                   |          |                |human-readable complement to the    |
|                   |          |                |machine-readable ``bbox`` member.)  |
+-------------------+----------+----------------+------------------------------------+
|``creator``        |string    |optional        |(Meta-data.) Name of the entity     |
|                   |          |                |primarily responsible for making the|
|                   |          |                |resource.                           |
+-------------------+----------+----------------+------------------------------------+
|``contributors``   |string    |optional        |(Meta-data.) Names of entities who  |
|                   |          |                |contributed to the resource.        |
+-------------------+----------+----------------+------------------------------------+
|``publisher``      |string    |optional        |(Meta-data.) Name of the entity     |
|                   |          |                |primarily responsible for making the|
|                   |          |                |resource available.                 |
+-------------------+----------+----------------+------------------------------------+
|``rights``         |string    |optional        |(Meta-data.) Rights held in and over|
|                   |          |                |the resource, such as copyright.    |
+-------------------+----------+----------------+------------------------------------+
|``license``        |URL       |optional        |(Meta-data.) URL of a license       |
|                   |          |                |granting privileges over the        |
|                   |          |                |resource. Use canonical URL when    |
|                   |          |                |possible.                           |
+-------------------+----------+----------------+------------------------------------+
|``morePermissions``|string    |optional        |(Meta-data.) Information about      |
|                   |          |                |additional privileges beyond those  |
|                   |          |                |granted by the license.             |
+-------------------+----------+----------------+------------------------------------+
|``dateCreated``    |timestamp |optional        |(Meta-data.) When the resource was  |
|                   |          |                |created.                            |
+-------------------+----------+----------------+------------------------------------+
|``dateModified``   |timestamp |optional        |(Meta-data.) When the resource was  |
|                   |          |                |last modified.                      |
+-------------------+----------+----------------+------------------------------------+
|``dateAdded``      |timestamp |optional        |(Meta-data.) When the resource was  |
|                   |          |                |added to the map set.               |
+-------------------+----------+----------------+------------------------------------+

Collection Class
~~~~~~~~~~~~~~~~

A Collection object is a Node that contains other Nodes.

Abstract class:
  Yes

Inherits from:
  Node

+-------------------+----------+----------------+------------------------------------+
|Member             |Type      |Values          |Meaning                             |
+===================+==========+================+====================================+
|``children``       |array of  |required        |Ordered list of children contained  |
|                   |Node      |                |in the collection.                  |
|                   |objects   |                |                                    |
+-------------------+----------+----------------+------------------------------------+

Document Class
~~~~~~~~~~~~~~

A Document object defines the top level of a MapSetJSON document. There must be exactly
one Document object in each MapSetJSON file.

Abstract class:
  No

Inherits from:
  Collection

+-------------------+---------------------+----------------+------------------------------------+
|Member             |Type                 |Values          |Meaning                             |
+===================+=====================+================+====================================+
|``mapsetjson``     |string               |required        |Version of the MapSetJSON           |
|                   |                     |                |specification the document conforms |
|                   |                     |                |to.  For example: ``"0.1"``. The    |
|                   |                     |                |existence of this member            |
|                   |                     |                |distinguishes MapSetJSON from other |
|                   |                     |                |JSON document types.                |
+-------------------+---------------------+----------------+------------------------------------+
|``url``            |string               |optional        |Canonical URL where this document   |
|                   |                     |                |can be found.                       |
+-------------------+---------------------+----------------+------------------------------------+
|``extensions``     |ExtensionsDeclaration|optional        |MapSetJSON extensions needed to     |
|                   |object               |                |interpret this document.            |
+-------------------+---------------------+----------------+------------------------------------+
|``view``           |View object          |optional        |View parameters for map when map set|
|                   |                     |                |is initially loaded. If no view is  |
|                   |                     |                |specified, the viewer should        |
|                   |                     |                |initially view the minimum-size     |
|                   |                     |                |geospatial area that contains all of|
|                   |                     |                |the map content visible when the map|
|                   |                     |                |set is first loaded. If no map      |
|                   |                     |                |content is initially visible, the   |
|                   |                     |                |viewer may use an arbitrary initial |
|                   |                     |                |view.                               |
+-------------------+---------------------+----------------+------------------------------------+

.. _U.S. Library of Congress Subject Headings: http://id.loc.gov/authorities/subjects.html

Document Example
----------------

::

  {
    // members inherited from Object
    "type": "Document",
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
    "publisher": "...",
    "rights": "Copyright (C) ...",
    "license": "http://creativecommons.org/licenses/ ...",
    "morePermissions": "You may also ...",
    "dateCreated": "2012-01-30T12:00:00Z",
    "dateModified": "2012-01-30T12:00:00Z",
    "dateAdded": "2012-01-30T12:00:00Z",

    // members inherited from Collection
    "children": [
      { (Node object 1) },
      ...
    ],

    // members defined in Document
    "mapsetjson": "0.1",
    "url": "http://example.com/canonicalUrlOfThisDocument.json",
    "extensions": { (ExtensionsDeclaration object) },
    "view": { (View object) }
  }


Layer Class
~~~~~~~~~~~

A Layer object is a Node that does not contain other Nodes. Concrete
subclasses of Layer are defined in MapSetJSON extensions.

Abstract class:
  Yes

Inherits from:
  Node

+-------------------+----------+----------------+------------------------------------+
|Member             |Type      |Values          |Meaning                             |
+===================+==========+================+====================================+
|``show``           |boolean   |``true``        |The layer's contents should be      |
|                   |          |                |displayed in the map when the map   |
|                   |          |                |set is first loaded.                |
|                   |          +----------------+------------------------------------+
|                   |          |``false``       |The layer's contents should not be  |
|                   |          |(default)       |displayed. Loading of the contents  |
|                   |          |                |should be postponed until the user  |
|                   |          |                |turns on visibility of the layer.   |
+-------------------+----------+----------------+------------------------------------+
|``drawOrder``      |integer   |optional        |Stacking order for overlapping      |
|                   |          |(default:       |content in the map. Viewers should  |
|                   |          |``1000``)       |render layers with higher values on |
|                   |          |                |top of layers with lower            |
|                   |          |                |values. Draw order specifications in|
|                   |          |                |the primary MapSetJSON document take|
|                   |          |                |precedence over those found in      |
|                   |          |                |linked content.                     |
+-------------------+----------+----------------+------------------------------------+
|``master``         |boolean   |``true``        |This layer is the master layer. (The|
|                   |          |                |document must not have more than one|
|                   |          |                |master layer.) If this layer's      |
|                   |          |                |contents contain interface controls,|
|                   |          |                |such as an initial view or a tour,  |
|                   |          |                |the viewer should use those controls|
|                   |          |                |for the overall map set             |
|                   |          |                |display. Interface controls         |
|                   |          |                |specified in the primary MapSetJSON |
|                   |          |                |document (see `View Class`_) take   |
|                   |          |                |precedence over those found in the  |
|                   |          |                |master layer.                       |
|                   |          +----------------+------------------------------------+
|                   |          |``false``       |This layer is not the master layer. |
|                   |          |(default)       |                                    |
+-------------------+----------+----------------+------------------------------------+
|``url``            |URL       |required        |Link to the content of the layer.   |
+-------------------+----------+----------------+------------------------------------+

.. View Class:

View Class
~~~~~~~~~~

A View object defines geospatial viewing parameters for a map.

Abstract class:
  Yes

Inherits from:
  Object

(No additional members.)

.. BoundingBoxView Class:

BoundingBoxView Class
~~~~~~~~~~~~~~~~~~~~~

A BoundingBoxView object specifies viewing parameters for a map in the
form of a bounding box. The viewer should display an area around the
specified bounding box.

Abstract class:
  No

Inherits from:
  View

+-------------------+----------+----------------+------------------------------------+
|Member             |Type      |Values          |Meaning                             |
+===================+==========+================+====================================+
|``crs``            |CRS       |optional        |Coordinate reference system used to |
|                   |          |(default: WGS84)|interpret coordinates in other      |
|                   |          |                |members of the object.              |
+-------------------+----------+----------------+------------------------------------+
|``bbox``           |bounding  |required        |The initial map view should be an   |
|                   |box       |                |area around this bounding box.      |
+-------------------+----------+----------------+------------------------------------+
|``scale``          |number    |optional        |Amount by which the bounding box    |
|                   |          |(default: ``1``)|should be scaled when calculating   |
|                   |          |                |the view. A value less than 1 means |
|                   |          |                |to show only a center subset of the |
|                   |          |                |bounding box. A value greater than 1|
|                   |          |                |means to include some area outside  |
|                   |          |                |the bounding box.                   |
+-------------------+----------+----------------+------------------------------------+

BoundingBoxView Example
-----------------------

This bounding box contains the entire world map and explicitly specifies
the default WGS84 CRS::

  {
    // members inherited from Object
    "type": "BoundingBox",

    // members defined in BoundingBoxView
    "crs": {
      "type": "name",
      "properties": {
        "name": "urn:ogc:def:crs:OGC:1.3:CRS84"
      }
    },
    "bbox": [
      [-180.0, -90.0],
      [180.0, 90.0]
    ],
    "scale": 1.0
  }

Extensions
==========

This document defines core components of the MapSetJSON specification. Anyone
may define extensions to the specification.

ExtensionsDeclaration Object
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

An ExtensionsDeclaration object declares the extensions that a
MapSetJSON document requires in order to be interpreted and displayed
properly.

 * The extensions object may have any number of name/value pairs.

 * Within each name/value pair, the value is a string URL pointing to
   the human-readable specification document for the extension, and the
   name declares the namespace the document will use to refer to types
   and members defined in that extension. Each extension name must be
   unique.

 * In the rest of the MapSetJSON document, types and members defined in
   an extension are identified using dot notation with the document's
   namespace for that extension. For example, if a "kml" extension is
   declared in the extensions object, and that extension defines the
   "KML" node type, the type would appear in that document as "kml.KML".

 * If an extension defines a new node type, member names within an
   instance of that node type need not be redundantly prefixed with the
   extension's namespace.

ExtensionsDeclaration Example
-----------------------------

::

    "extensions": {
      "kml": "http://mapmixer.org/mapsetjson/ext/kml/0.1/",
      "geojson": "http://mapmixer.org/mapsetjson/ext/geojson/0.1/"
    }


Creating New Extensions
~~~~~~~~~~~~~~~~~~~~~~~

 * An extension is created by publishing a human-readable specification document
   like this one at a URL accessible to implementers and document authors.

 * Extensions may define new node types and specify their behavior. By
   convention, type names should be in UpperCamelCase.

 * Extensions may define new members for types defined in the core
   specification and in other extensions. By convention, member names
   should be in lowerCamelCase.

 * The MapSetJSON working group will maintain a `MapSetJSON Extension
   Registry`_.  Publishers of new extensions should inform the working
   group as outlined at the `MapSetJSON Home Page`_.

 * Any viewer implementing this core specification is said to be
   "MapSetJSON compliant". Viewers should also document which extensions
   they support, if any.

 * In the event that a viewer does not implement all of the extensions
   required by a document, the viewer's display of the map set should
   degrade gracefully:

   * Members with unrecognized names or belonging to an unknown
     namespace should not cause a fatal error.

   * If a node's type is in the namespace of an unsupported extension,
     the viewer should examine the "alternateTypes" member and interpret
     the node as one of those types if possible.

.. _MapSetJSON Extension Registry: http://mapmixer.org/mapsetjson/ext/registry/
.. _MapSetJSON Home Page:  http://mapmixer.org/mapsetjson/
   
.. Layer Selection Interface:

Layer Selection Interface
=========================

When a map set has many layers, viewing all of them simultaneously may
be too resource intensive or create overwhelming map clutter. The layer
selection interface allows users to control which layers are visible and
when their contents are loaded.

Layer Selection Example
~~~~~~~~~~~~~~~~~~~~~~~

This document::

  {
    ...
    "children": [
      {
        "type": "kml.KML",
        "name": "Earthquake Intensity",
        "url": "http://mapmixer.org/mapsetjson/example/eqintensity.kml",
        "show": true
      },
      {
        "type": "geojson.GeoJSON",
        "name": "Fire Vehicle Locations",
        "url": "http://mapmixer.org/mapsetjson/example/vehicles.json"
      }
    ]
    ...
  }

Corresponds to this listing in a layer selection interface::

  [X] Earthquake Intensity
  [ ] Fire Vehicle Locations

The brackets are filled ``[X]`` or empty ``[ ]`` showing whether or not
the map data is visible in the initial view based on the "show" member,
which is false by default.

Layer Selection Interface Affordances
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The layer selection interface includes an entry for each MapSetJSON
node. Each node entry should provide the following affordances:

 * Show/Hide: The user should be able to show the node (displaying its
   contents in the map) and hide the node.

 * Display Load State: There should be a display (for example, an icon
   in the node entry) that distinguishes between the following load
   states:

   * Unloaded: The viewer has not yet attempted to load the node (it is hidden).

   * Loading: The viewer is fetching, parsing, or rendering the node contents.

   * Loaded: The node contents are visible in the map.

   * Error: There was a problem with fetching, parsing, or rendering the node.

 * Refresh: The user should be able to refresh the node contents, causing
   the viewer to fetch and render any updated external data.

 * View Error: The user should be able to get additional information about the
   error state of a node.

.. _GeoJSON CRS specification: http://geojson.org/geojson-spec.html#coordinate-reference-system-objects
.. _GeoJSON bounding box specification: http://geojson.org/geojson-spec.html#bounding-boxes

Acknowledgments
===============

Parts of this specification are modeled on GeoJSON_, KML_, the `Dublin
Core Metadata Element Set`_ and the `Creative Commons Rights Expression
Language`_.

.. _GeoJSON: http://geojson.org/geojson-spec.html
.. _KML: http://code.google.com/apis/kml/documentation/kmlreference.html

The authors would like to thank the following early readers for their
constructive feedback:

 * Ted Scharff (NASA Ames Research Center)
 * Matt Deans (NASA Ames Research Center)
 * David Lees (NASA Ames Research Center)
 * Tamar Cohen (NASA Ames Research Center)

Footnotes
=========

.. [#visibilityControl] The visibilityControl member is modeled on KML's listItemType_.

.. [#meta] These members are roughly modeled on the `Dublin Core Metadata Element Set`_ and
   the `Creative Commons Rights Expression Language`_.

.. _listItemType: http://code.google.com/apis/kml/documentation/kmlreference.html#listItemType

 .. _Dublin Core Metadata Element Set: http://dublincore.org/documents/dces/

 .. _Creative Commons Rights Expression Language: http://wiki.creativecommons.org/CcREL
