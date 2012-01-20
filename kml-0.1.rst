
==============================================
KML Extension for the MapSetJSON Specification
==============================================

Authors
  Trey Smith (Carnegie Mellon University)

Revision
  Pre-0.1 draft

Date
  20 Jan 2012

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

.. _MapSetJSON Core Specification: http://mapmixer.org/mapsetjson/spec/0.1/


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

KML Node Type
=============

A KML node ("type": "kml.KML") declares a map layer that links to KML
content:

 * The behavior of the KML node is modeled on the behavior of the
   `MapSetJSON Link Node Type`_.

 * A KML node must have a member "url", whose value is a string
   specifying the URL of the KML document. The URL may contain a
   fragment identifier starting with a hash mark #.  If so, the fragment
   must refer to a node in the external document by its <id> member.
   The viewer must use the referenced node in place of the subdocument's
   root node.

 * A KML node may have members "open" and "visibilityControl" whose
   meaning is the same as for folder nodes.

 * Like MapSetJSON documents, KML documents have a root node. If the
   root node is a collection such as a <Folder> or a <Document>, it
   has children for the purposes of the discussion below. If the root
   node is not a collection, it has no children.

 * Unless the KML node is initially visible, loading of the subdocument
   must be postponed until the user turns on the link's visibility.

 * When a KML node becomes visible, the viewer must load the subdocument
   and should display the top-level children of the subdocument root
   node as direct children of the KML node. The viewer must not display
   the subdocument root node as a separate entry. Interface properties
   of the displayed entry ("name", "open", "visibilityControl") may be
   specified in either the KML node or the subdocument root node,
   with the value of each member in the KML node overriding the value
   in the subdocument root node if both are specified.

 * For the purposes of controlling the layer selection interface, the
   following equivalencies hold between MapSetJSON members and KML
   members:

   * MapSetJSON "open" = KML <open>. Corresponding values: true=1, false=0.

   * MapSetJSON "visibilityControl" = KML <listItemStyle>.

 * Some viewer implementations may be able to display KML content
   without being able to introspect it in the layer selection
   interface. These implementations should document that they "implement
   the KML extension without introspection support".

.. _MapSetJSON Link Node Type: http://mapmixer.org/mapsetjson/spec/0.1/#link-node-type
