
=================================================
Folder Extension for the MapSetJSON Specification
=================================================

Authors
  Trey Smith (Carnegie Mellon University)

Revision
  Pre-0.1 draft

Date
  30 Jan 2012

Canonical URL of this document
  http://mapmixer.org/mapsetjson/ext/folder/0.1/

Further information
  http://mapmixer.org/mapsetjson/

.. contents::
   :depth: 2

.. sectnum::

Introduction
============

This extension adds the ability to organize map layers into folders
within a map set.  It extends the `MapSetJSON Core Specification`_.

.. _MapSetJSON Core Specification: http://mapmixer.org/mapsetjson/spec/0.1/


Examples
========

This MapSetJSON document::

  {
    "mapsetjson": "0.1",
    "type": "Document",
    "extensions": {
      "folder": "http://mapmixer.org/mapsetjson/ext/folder/0.1/",
      "kml": "http://mapmixer.org/mapsetjson/ext/kml/0.1/",
    },
    "children": [
      {
        "type": "folder.Folder",
        "open": true,
        "children": [
          {
            "type": "kml.KML",
            "name": "Layer 1.A",
            "url": "...",
            "show": true
          },
          {
            "type": "folder.Folder",
            "name": "Folder 1.B",
            "open": true,
            "children": [
              {
                "type": "kml.KML",
                "name": "Layer 1.B.1",
                "url": "..."
              },
              {
                "type": "kml.KML",
                "name": "Layer 1.B.2",
                "url": "..."
              }
            ]
          }
        ]
      }
    ]
  }

Has this hierarchical organization::

  [ ] Folder 1
   |--[X] Layer 1.A
   +--[ ] Folder 1.B
       |--[ ] Layer 1.B.1
       +--[ ] Layer 1.B.2

The brackets are filled ``[X]`` or empty ``[ ]`` showing whether or not
the map data is visible in the initial view based on the "show" member,
which is false by default.

FolderLike Class
================

A FolderLike object (``"type": "folder.FolderLike"``) is a Node that has
children of some kind (though it may not have a ``children``
member). Its entry in the layer selection interface can be opened and
collapsed, and it may provide the user an affordance to control the
visibility of its children.

Abstract class:
  Yes

Inherits from:
  Node

+---------------------+-----------+-----------------------+------------------------------------+
|Member               |Type       |Values                 |Meaning                             |
+=====================+===========+=======================+====================================+
|``open``             |boolean    |``true``               |The viewer's layer selection        |
|                     |           |                       |interface will display the folder in|
|                     |           |                       |the open state when first loaded.   |
|                     |           +-----------------------+------------------------------------+
|                     |           |``false``              |The viewer will display the folder  |
|                     |           |(default)              |in the collapsed state.             |
+---------------------+-----------+-----------------------+------------------------------------+
|``visibilityControl``|enumerated |``"check"`` (default)  |The visibility of each folder child |
|[#visibilityControl]_|(string)   |                       |is tied to the value of its         |
|                     |           |                       |checkbox. Checking the folder       |
|                     |           |                       |checkbox toggles the visibility of  |
|                     |           |                       |all folder children.                |
|                     |           +-----------------------+------------------------------------+
|                     |           |``"radioFolder"``      |At most one child may be visible at |
|                     |           |                       |a time.                             |
|                     |           +-----------------------+------------------------------------+
|                     |           |``"checkOffOnly"``     |The user may not turn on all        |
|                     |           |                       |children by checking the folder     |
|                     |           |                       |checkbox. This setting is useful    |
|                     |           |                       |when loading all children at the    |
|                     |           |                       |same time would be too resource     |
|                     |           |                       |intensive or create overwhelming map|
|                     |           |                       |clutter.                            |
|                     |           +-----------------------+------------------------------------+
|                     |           |``"checkHideChildren"``|The visibility of all folder        |
|                     |           |                       |children should be controlled by the|
|                     |           |                       |visibility of the folder. The       |
|                     |           |                       |children themselves should not be   |
|                     |           |                       |displayed in the layer selection    |
|                     |           |                       |interface. The user may not open the|
|                     |           |                       |folder.                             |
+---------------------+-----------+-----------------------+------------------------------------+

FolderLike Interface Affordances
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

FolderLike objects should have all the affordances provided by nodes, and
the following additional affordance:

 * Open/Collapse: The user should be able to open the folder (displaying
   the node entries of its children in the layer selection interface)
   and collapse the folder (hiding the node entries of its children).

Folder Class
============

A Folder object (``"type": "folder.Folder"``) declares a Folder that
contains other Node objects (subfolders or Layers).

Abstract class:
  No

Inherits from:
  Collection, FolderLike

(No additional members.)

Folder Example
~~~~~~~~~~~~~~

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

    // members inherited from FolderLike
    "open": false,
    "visibilityControl": "check",
  }

Footnotes
=========

.. [#visibilityControl] The visibilityControl member is modeled on KML's listItemType_.

.. _listItemType: http://code.google.com/apis/kml/documentation/kmlreference.html#listItemType
