
==================================================
Include Extension for the MapSetJSON Specification
==================================================

Authors
  Trey Smith (Carnegie Mellon University)

Revision
  Pre-0.1 draft

Date
  31 Jan 2012

Canonical URL of this document
  http://mapmixer.org/mapsetjson/ext/include/0.1/

Further information
  http://mapmixer.org/mapsetjson/

.. contents::
   :depth: 2

.. sectnum::

Introduction
============

This extension adds the ability to include external MapSetJSON documents
within a map set.  It extends the `MapSetJSON Core Specification`_. It
depends on the `MapSetJSON Folder Extension`_.

.. _MapSetJSON Core Specification: http://mapmixer.org/mapsetjson/spec/0.1/
.. _MapSetJSON Folder Extension: http://mapmixer.org/mapsetjson/ext/folder/0.1/

Examples
========

This map set includes an external MapSetJSON subdocument::

  {
    "mapsetjson": "0.1",
    "type": "Document",
    "extensions": {
      "folder": "http://mapmixer.org/mapsetjson/ext/folder/0.1/",
      "include": "http://mapmixer.org/mapsetjson/ext/include/0.1/",
      "kml": "http://mapmixer.org/mapsetjson/ext/kml/0.1/",
    },
    "children": [
        {
          "type": "kml.KML",
          "name": "Earthquake Intensity",
          "url": "..."
        },
        {
          "type": "include.Include",
          "name": "Partner Agency Layers",
          "url": "http://example.com/partnerAgencyLayers.json",
          "show": true,
          "open": true
        }
      }
    ]
  }

If the target of the include at
``"http://example.com/partnerAgencyLayers.json"`` is this MapSetJSON
subdocument::

  {
    "mapsetjson": "0.1",
    "type": "Document",
    "extensions": {
      "kml": "http://mapmixer.org/mapsetjson/ext/kml/0.1/",
    },
    "children": [
      {
        "type": "kml.KML",
        "open": true,
        "children": [
          {
            "type": "kml.KML",
            "name": "Weather",
            "show": true,
            "url": "..."
          },
          {
            "type": "kml.KML",
            "name": "Flood Levels",
            "url": "..."
          }
        ]
      }
    ]
  }

Then the subdocument is included within the primary document and the
resulting hierarchical organization in the layer selection interface
would be the following::

  [ ] Earthquake Intensity
  [X] Partner Agency Layers
   |--[X] Weather
   +--[ ] Flood Levels

The brackets are filled ``[X]`` or empty ``[ ]`` showing whether or not
the map data is visible in the initial view.

Note that in the initial view:

 * The subdocument is immediately loaded and its Weather and Flood
   Levels layers appear in the layer selection interface because the
   ``show`` member of the Include object is ``true``.

 * After the subdocument is loaded, the initial map visibility of its
   layers is controlled by their ``show`` members. The Weather layer is
   loaded and visible in the map but the Flood Levels layer is not.

Include Class
=============

An Include object causes the interpreter to load a node of an external
MapSetJSON document (called the "included node" of the "subdocument")
into the folder hierarchy of a map set.

The viewer should load the subdocument either at initial viewing
of the map set (if the ``show`` member is ``true``), or when the user
turns on visibility of the Include object's entry in the layer selection
interface.

By default, the included node is the top-level document node of the
subdocument. However, if the ``url`` member contains a fragment starting
with ``#``, the fragment must be the ``id`` member of a node in the
subdocument, and that node is the included node.

When the subdocument is loaded the viewer should display the children of
the included node as direct children of the Include object in the layer
selection interface. The viewer must not display the included node
itself as a separate entry.

Note that the included node may be a Layer node with no children. In
that case no children are displayed, and the Include object members
inherited from FolderLike (``open``, ``visibilityControl``) are ignored.

Interface properties of the displayed entry (``name``, ``open``,
``visibilityControl``) may be specified in either the Include object or
the included node. Values in the Include object take precedence.

Abstract class:
  No

Inherits from:
  Node, folder.FolderLike

+---------------------+--------+-----------------------+------------------------------------+
|Member               |Type    |Values                 |Meaning                             |
+=====================+========+=======================+====================================+
|``url``              |URL     |required               |The URL of the subdocument.  May    |
|                     |        |                       |specify the ``id`` of the included  |
|                     |        |                       |node as the fragment part of the    |
|                     |        |                       |URL.                                |
+---------------------+--------+-----------------------+------------------------------------+
|``show``             |boolean |``true``               |The subdocument should be loaded    |
|                     |        |                       |immediately when the map set is     |
|                     |        |                       |first viewed.                       |
|                     |        +-----------------------+------------------------------------+
|                     |        |``false`` (default)    |Loading of the subdocument should be|
|                     |        |                       |postponed until the user turns on   |
|                     |        |                       |visibility of the Include object.   |
+---------------------+--------+-----------------------+------------------------------------+

Include Example
~~~~~~~~~~~~~~~

::

  {
    // members inherited from Object
    "type": "folder.Folder",
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

    // members inherited from folder.FolderLike
    "open": false,
    "visibilityControl": "check",

    // members defined in Include
    "url": "http://example.com/externalMapSet.json#optionalIdOfNodeInExternalDocument",
    "show": false
  }
