
===================================
The MapSetJSON Format Specification
===================================

Authors
  Trey Smith (Carnegie Mellon University)

Revision
  Pre-0.1 draft

Date
  20 Jan 2012

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

Example
=======

::

  {
    "mapsetjson": "0.1",
    "extensions": {
      "kml": "http://mapmixer.org/mapsetjson/ext/kml/0.1/",
      "geojson": "http://mapmixer.org/mapsetjson/ext/geojson/0.1/"
    },
    "root": {
      "type": "Folder",
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
  }

Definitions
===========

 * The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in `IETF RFC 2119`_.

 * JavaScript Object Notation (JSON), and the terms object, name, value, array, and number, are defined in `IETF RTC 4627`_.
   MapSetJSON documents have the standard JSON MIME type, "application/json".

.. _IETF RFC 2119: http://www.ietf.org/rfc/rfc2119.txt
.. _IETF RTC 4627: http://www.ietf.org/rfc/rfc4627.txt

MapSetJSON Object
=================

MapSetJSON always consists of a single object. This object (referred to
as the MapSetJSON object below) represents a set of map layers.

 * The MapSetJSON object may have any number of members (name/value pairs).

 * The MapSetJSON object must have a member with the name "mapsetjson",
   the value of which must be a string identifying the version of the
   MapSetJSON specification the document conforms to.  For example:
   "0.1". The existence of this member distinguishes MapSetJSON from
   other JSON document types.

 * The MapSetJSON object may have a "url" member, the value of which
   must be a string indicating a canonical URL where the document may be
   found.

 * The MapSetJSON object may have an "extensions" member, the value of
   which must be an extensions object (see Extensions_).

 * The MapSetJSON object may have a "view" member, the value of which
   must be a view object (see `View Object`_).

 * The MapSetJSON object must have a "root" member, the value of which
   must be a folder node object (see `Folder Node Type`_).

 * The MapSetJSON object may have other members defined in extensions
   (see Extensions_). In general, viewers should ignore MapSetJSON
   object members whose names they do not recognize.

MapSetJSON Object Example
~~~~~~~~~~~~~~~~~~~~~~~~~

::

  {
    "mapsetjson": "0.1",
    "url": "http://example.com/thisDocument.json",
    "extensions": {
      ...
    },
    "view": {
    },
    "root": {
      ...
    }
  }

.. Layer Selection Interface:

Layer Selection Interface
=========================

When a map set has many layers, viewing all of them simultaneously may
be too resource intensive or create overwhelming map clutter. The layer
selection interface allows users to control which layers are visible and
when their contents are loaded.

MapSetJSON document authors can organize their layers hierarchically in
folders and control the ordering of folder children. This organization,
which controls the presentation of the layer selection interface, can
help users to find the right layer in a large map set.

Layer Hierarchy Example
~~~~~~~~~~~~~~~~~~~~~~~

This folder hierarchy::

  {
    "type": "Folder",
    "name": "Folder 1",
    "children": [
      {
        "type": "Link",
        "name": "Link 1.A",
        "url": "...",
        "show": true
      },
      {
        "type": "Folder",
        "name": "Folder 1.B",
        "children": [
          {
            "type": "Link",
            "name": "Link 1.B.1",
            "url": "..."
          },
          {
            "type": "Link",
            "name": "Link 1.B.2",
            "url": "..."
          }
        ]
      }
    ]
  }

Corresponds to this hierarchical display::

  [ ] Folder 1
   |--[X] Link 1.A
   |--[ ] Folder 1.B
       |--[ ] Link 1.B.1
       |--[ ] Link 1.B.2

In this initial view, the empty brackets [ ] represent hidden map data
and the filled brackets [X] represent visible map data, based on the
"show" member which is false by default.

Layer Selection Interface Affordances
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

The layer selection interface includes an entry for each MapSetJSON
node. Each node entry should provide the following affordances:

 * Show/Hide: The user should be able to show the node (displaying its
   contents in the map) and hide the node.

 * Open/Collapse: If the node entry is for a collection type (a folder
   node, or a link node after the referenced subdocument has been
   loaded), the user should be able to open the node (displaying the
   node entries of its children in the layer selection interface) and
   collapse the node (hiding the node entries of its children).

 * Load State: There should be a display (for example, an icon in the
   node entry) that distinguishes between the following load states:

   * Unloaded: The viewer has not yet attempted to load the node (it is hidden).

   * Loading: The viewer is fetching, parsing, or rendering the node contents.

   * Loaded: The node contents are visible in the map.

   * Error: There was a problem with fetching, parsing, or rendering the node.

 * Refresh: The user should be able to refresh the node contents, causing
   the viewer to fetch and render any updated external data.

 * View Error: The user should be able to get additional information about the
   error state of a node.

Node Objects
============

The "map set" of MapSetJSON is actually a tree whose leaf nodes are
links to map content and whose internal nodes are folders. Node objects
represent nodes of the tree.

 * A node object may have any number of members (name/value pairs).

 * A node object must have a "type" member, the value of which must
   be a string indicating the type of node (several types are defined
   later in this section, and extensions may define additional types).

 * A node object may have an "alternateTypes" member, the value of which
   must be an array of strings indicating alternate types.  If a viewer
   does not support the type given in the "type" field, it should
   attempt to fall back to interpreting the node using one of the types
   in the "alternateTypes" field, trying them in order and using the
   first one that it supports.

 * A node object may have a "name" member, the value of which must be
   a string specifying the name of the node as it should be displayed
   in the layer selection interface (see `Layer Selection Interface`_).

 * A node object may have an "id" member, the value of which must be a
   string specifying an identifier for the node. The identifier for each
   node, if specified, must be unique over the scope of the MapSetJSON
   document.

 * A node object may have a "show" member, the value of which must be a
   boolean indicating the visibility of the node's contents:

   * true: The node's contents should be displayed in the map when the
     map set is first loaded.

   * false (default): The node's contents should not be
     displayed. Furthermore, loading of the contents should be postponed
     until the user turns on visibility of the node.

 * A node object may have a "drawOrder" member, the value of which must
   be an integer defining the stacking order for map data in overlapping
   layers. Viewers should render layers with higher values on top of
   layers with lower values. Draw order specifications in the primary
   MapSetJSON document take precedence over those found in linked
   subdocuments.

 * A node object may have a "master" member, the value of which must be
   a boolean indicating whether this is the master node for the map
   set. The document must not have more than one master node.

   * true: The node is the master node. If the node's contents contain
     interface controls, such as an initial view or a tour, the viewer
     should use those controls for the overall map set display.  If the
     primary MapSetJSON document and the master node contents both
     specify an interface control (see `View Object`_), the value in the
     primary document takes precedence.

   * false (default): The node is not the master node.

 * Other members of the node object are interpreted according to its
   type, as defined below and in extensions to the MapSetJSON
   specification. In general, viewers should ignore node object members
   whose names they do not recognize.

This specification defines core node types. Additional node types are
defined by extensions (see Extensions_).

.. Folder Node Type:

Folder Node Type
~~~~~~~~~~~~~~~~

A folder node ("type": "Folder") defines a ordered collection of node
objects, which can include subfolders.

 * A folder node must have a "children" member, whose value must be
   an array of node objects.

 * A folder node may have an "open" member, whose value must be a
   boolean:

   * true: The viewer's layer selection interface will display
     the folder in the open state when first loaded.

   * false (default): The viewer will display the folder in the
     collapsed state.

 * A folder node may have an "visibilityControl" member, whose value
   must be a string specifying how the folder's children should appear
   in the layer selection interface [#visibilityControl]_:

   * "check" (default): The visibility of each folder child is tied to
     the value of its checkbox. Checking the folder checkbox toggles
     the visibility of all folder children.

   * "radioFolder": At most one child may be visible at a time.

   * "checkOffOnly": The user may not turn on all children by checking
     the folder checkbox. This setting is useful when loading all
     children at the same time would be too resource intensive or create
     overwhelming map clutter.

   * "checkHideChildren": The visibility of all folder children should
     be controlled by the visibility of the folder. The children
     themselves should not be displayed in the layer selection
     interface. The user may not open the folder.

Folder Node Type Example
------------------------

::

  {
    "type": "Folder",
    "name": "Weather",
    "open": false,
    "visibilityControl": "check",
    "children": [
      ...
    ]
  }

Root Folder
-----------

Viewers should display the folder specified as the "root" member of the
MapSetJSON object differently from other folders.

 * If the MapSetJSON document is the primary document (that is, the
   primary subject of the view), the viewer should not display its root
   folder itself in the layer selection interface. The root folder's
   "open" member should be ignored, and its children should be listed as
   the top-level items in the layer selection interface.

 * Since the root folder is not displayed in the layer selection
   interface, the viewer may provide a "show all" checkbox widget used
   to toggle all children of the root folder. However, the "show all"
   widget should not be displayed if the root folder's
   "visibilityControl" member is specified to be a value other than
   the default "check".

 * If the MapSetJSON document is the primary subject of the view, the
   viewer may use the "name" member of its root folder as the title of
   the view.

.. Link Node Type:

Link Node Type
~~~~~~~~~~~~~~

A link node ("type": "Link") defines a link to an external MapSetJSON
document, called the "subdocument" of the link.

 * A link node must have a member "url", whose value is a string
   specifying the URL of the subdocument. The URL may contain a fragment
   identifier starting with a hash mark #.  If so, the fragment must
   refer to a node in the external document by its "id" member.  The
   viewer must use the referenced node in place of the subdocument's
   root node.

 * A link node may have members "open" and "visibilityControl" whose
   meaning is the same as for folder nodes.

 * Unless the link node is initially visible, loading of the subdocument
   must be postponed until the user turns on the link's visibility.

 * When a link node becomes visible, the viewer must load the
   subdocument and should display the top-level children of the
   subdocument root folder as direct children of the link node. The
   viewer must not display the subdocument root folder as a separate
   entry. Interface properties of the displayed entry ("name", "open",
   "visibilityControl") may be specified in either the link node or the
   subdocument root folder, with the value of each member in the link
   node overriding the value in the subdocument root folder if both are
   specified.
   
Link Node Type Example
----------------------

::

  {
    "type": "Link",
    "name": "Subfolder Managed by External Organization",
    "url": "http://example.com/externalLayers.json",
    "show": false,
    "open": false,
    "visibilityControl": "check"
  }

.. View Object:

View Object
===========

The view object ("view" member of the MapSetJSON object) specifies
the initial map view when the map set is first loaded.

 * The view object may have any number of members (name/value pairs).

 * The view object must have a "type" member, the value of which must be
   a string indicating the type of view. This specification defines the
   `Bounding Box View Type`_. Extensions may define additional
   types.

 * If no view object is specified, the viewer should initially view the
   minimum-size geospatial area that contains all of the map content
   visible when the map set is first loaded. If no map content is
   initially visible, the viewer may use an arbitrary initial view.

.. Bounding Box View Type:

Bounding Box View Type
~~~~~~~~~~~~~~~~~~~~~~

A bounding box view ("type": "BoundingBox") specifies that the map
should view the minimum-size area containing the given geospatial
bounding box.

 * A bounding box view may have a "crs" member, the value of which is a
   coordinate reference system (CRS) object, as defined in the `GeoJSON
   CRS specification`_.  This CRS specifies how to interpret the
   bounding box coordinates.  The default CRS is a geographic coordinate
   reference system, using the WGS84 datum, and with longitude and
   latitude units of decimal degrees.

 * A bounding box view must have a "bbox" member, the value of which is
   an array of coordinate pairs as defined in the `GeoJSON bounding box
   specification`_.

.. _GeoJSON CRS specification: http://geojson.org/geojson-spec.html#coordinate-reference-system-objects
.. _GeoJSON bounding box specification: http://geojson.org/geojson-spec.html#bounding-boxes

Bounding Box View Type Example
------------------------------

This bounding box contains the entire world map and explicitly specifies
the default WGS84 CRS::

  {
    "type": "BoundingBox",
    "crs": {
      "type": "name",
      "properties": {
        "name": "urn:ogc:def:crs:OGC:1.3:CRS84"
      }
    },
    "bbox": [
      [-180.0, -90.0],
      [180.0, 90.0]
    ]
  }

.. Extensions:

Extensions
==========

This document defines core components of the MapSetJSON specification. Anyone
may define extensions to the specification.

Extensions Object
~~~~~~~~~~~~~~~~~

The extensions object ("extensions" member of the MapSetJSON object)
specifies the extensions that a MapSetJSON document requires in order to
be interpreted and displayed properly.

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

Extensions Object Example
-------------------------

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
   
Acknowledgments
===============

This specification was modeled in part on GeoJSON_ and KML_.

.. _GeoJSON: http://geojson.org/geojson-spec.html
.. _KML: http://code.google.com/apis/kml/documentation/kmlreference.html

The authors would like to thank the following early readers for their
constructive feedback:

 * Ted Scharff (NASA Ames Research Center)

Footnotes
=========

.. [#visibilityControl] The visibilityControl member is modeled on KML's listItemType_.

.. _listItemType: http://code.google.com/apis/kml/documentation/kmlreference.html#listItemType
