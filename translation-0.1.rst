
======================================================
Translation Extension for the MapSetJSON Specification
======================================================

Authors
  Trey Smith (Carnegie Mellon University)

Revision
  Pre-0.1 draft

Date
  20 Jan 2012

Canonical URL of this document
  http://mapmixer.org/mapsetjson/ext/translation/0.1/

Further information
  http://mapmixer.org/mapsetjson/

.. contents::
   :depth: 2

.. sectnum::

Introduction
============

This extension adds the ability to translate text labels in
multiple languages.  It extends the `MapSetJSON Core Specification`_.

.. _MapSetJSON Core Specification: http://mapmixer.org/mapsetjson/spec/0.1/


Example
========

This document provides Spanish (es) and English (en) translations for
all text labels and subdocuments, and provides French (fr) and Chinese
(cn) translations for some but not all elements. If the user does not
specify a language preference, the displayed language defaults to
French, or to English as a fallback::

  {
    "mapsetjson": "0.1",
    "extensions": {
      "translation": "http://mapmixer.org/mapsetjson/ext/translation/0.1/",
      "kml": "http://mapmixer.org/mapsetjson/ext/kml/0.1/"
    },
    "root": {
      "type": "Folder",
      "children": [
        {
          "type": "kml.KML",
          "name": "Meteo",
          "url": "http://mapmixer.org/mapsetjson/example/weather-es.kml"
        }
        {
          "type": "kml.KML",
          "name": "Niveles de Inundación",
          "url": "http://mapmixer.org/mapsetjson/example/floodLevels-es.kml"
        }
      ]
    },
    "translation.defaultLanguages": ["fr", "en"],
    "translation.text": {
      "Meteo": {
        "es": "Meteo",
        "en": "Weather",
        "fr": "Météo"
      },
      "Niveles de Inundación": {
        "es": "Niveles de Inundación",
        "en": "Flood Levels"
      }
    },
    "translation.urls": {
      "http://mapmixer.org/mapsetjson/example/weather-es.kml": {
        "es": "http://mapmixer.org/mapsetjson/example/weather-es.kml",
        "en": "http://mapmixer.org/mapsetjson/example/weather-en.kml"
        "cn": "http://mapmixer.org/mapsetjson/example/weather-cn.kml"
      },
      "http://mapmixer.org/mapsetjson/example/floodLevels-es.kml": {
        "es": "http://mapmixer.org/mapsetjson/example/floodLevels-es.kml",
        "en": "http://mapmixer.org/mapsetjson/example/floodLevels-en.kml"
      }
    }
  }

Localizing the example above according to the default language
preferences would yield the following document. Note that the English
translation is used for elements where a French translation is not
available::

  {
    "mapsetjson": "0.1",
    "extensions": {
      "kml": "http://mapmixer.org/mapsetjson/ext/kml/0.1/"
    },
    "root": {
      "type": "Folder",
      "children": [
        {
          "type": "kml.KML",
          "name": "Météo",
          "url": "http://mapmixer.org/mapsetjson/example/weather-en.kml"
        }
        {
          "type": "kml.KML",
          "name": "Flood levels",
          "url": "http://mapmixer.org/mapsetjson/example/floodLevels-en.kml"
        }
      ]
    }
  }


Translation Members
===================

This extension defines new members for the MapSetJSON object:

 * The MapSetJSON object may have a member
   "translation.defaultLanguages", whose value is an array of strings
   specifying preferred languages, in order from most to least
   preferred, which should be presented to users who do not otherwise
   specify a language preference. See `Localization Behavior`_.

 * The MapSetJSON object may have a member "translation.text", whose
   value is a translation object that provides localized versions of
   text labels ("name" members). See `Translation Objects`_.

 * The MapSetJSON object may have a member "translation.urls", whose
   value is a translation object that provides URLs ("url" members)
   referring to localized versions of linked subdocuments. See
   `Translation Objects`_.

.. Localized String Objects:

Localized String Objects
========================

A localized string object specifies multiple values of a string
localized to different languages. The string may be text in the given
language, or it may be a URL that refers to a document in the given
language.

 * A localized object may have any number of name/value pairs. The name
   is the code for a language specified according to `IETF BCP 47`_.
   The value is the version of the string for that language.

.. _IETF BCP 47: http://www.rfc-editor.org/rfc/bcp/bcp47.txt

Localized String Object Examples
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This localized string provides English (en) and Spanish (es) language
versions of a text label::

  {
    "en": "Weather",
    "es": "Meteo"
  }

This localized string provides URLs referring to English (en) and
Spanish (es) language versions of a document::

  {
    "en": "http://example.com/layer-en.json",
    "es": "http://example.com/layer-es.json"
  }    

.. Translation Objects:

Translation Objects
===================

A translation object specifies a lookup table of language translations.

 * A translation object may have any number of name/value pairs. The name
   specifies an original string as it appears in the MapSetJSON document.
   The value is a localized string object (see `Localized String Objects`_).

Translation Object Example
~~~~~~~~~~~~~~~~~~~~~~~~~~

This translation object specifies English (en) and Spanish (es) language
versions of two text labels. The names of the name/value pairs specify
the original version of the label that appears in the MapSetJSON
document::

  {
    "Meteo": {
      "en": "Weather",
      "es": "Meteo"
    },
    "Niveles de Inundación": {
      "en": "Flood Levels",
      "es": "Niveles de Inundación"
    }
  }

.. Localization Behavior:

Localization Behavior
=====================

The viewer should display multi-language documents in its user's
preferred languages.

 * For each text label ("name" member), the viewer should look up that
   text label's value in the "translations.text" translation object and
   display the localized text for the user's preferred language in the
   layer selection interface.

 * For each URL ("url" member), the viewer should look up that URL's
   value in the "translations.url" translation object and load the
   linked subdocument from the localized URL for the user's preferred
   language.

 * The viewer should use platform-appropriate queries (to the operating
   system, web browser, etc.) to infer the user's preferred language. If
   the viewer is unable to automatically infer the preferred language,
   it should fall back to the "translation.defaultLanguages" value. A
   user language preference interface should also be provided.

 * Note that the user's most preferred language may not always be
   present in the localized string object. Therefore, it may be helpful
   for the viewer to track multiple preferred languages in preference
   order.

 * The viewer should also be cognizant of partial language matches.  For
   example, if the user's preferred language is "en-US" (US English),
   then a translation in "en" (English with no country designation) is
   preferred to a translation in "es" (Spanish with no country
   designation). See `IETF BCP 47`_ for an in-depth discussion.

Server Side Localization
========================

Localization is the process of converting a multi-language MapSetJSON
document to a localized document in a preferred language (or a mix of
preferred languages).  Each text label is replaced by the localized
version of the label, each URL is replaced by the localized version of
the URL, and the translation extension and translation-related fields
are removed from the document.

We recognize that in some cases it may be better to perform document
localization on the server side, either to reduce network bandwidth or
to simplify the client-side viewer implementation. When doing
server-side localization, we recommend that the server provide an
explict menu of localized document versions [#acceptLanguage]_.

.. _HTTP Header Field Definitions: http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html

Footnotes
=========

.. [#acceptLanguage] The ``Accept-Language`` HTTP header is intended to
   specify user language preference but is rarely used in practice (see
   `HTTP Header Field Definitions`_).
