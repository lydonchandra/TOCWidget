http://lydon.ch/content/tocwidget-esri-arcgis-flexviewer-25

It's quite hard to find the previous versions of TOCWidget written by Robert Scheitlin
http://www.arcgis.com/rc/item.html?id=e2cb71d5c04d40d19e9f945ae0db7ce8
http://forums.arcgis.com/threads/18453-Table-of-Contents-Legend-Widget-for-FlexViewer-2.x

Now people can find it on GitHub (for 2.4 and 2.5 ArcGIS Viewer for Flex)
https://github.com/lydonchandra/TOCWidget 

For TOCWidget version 2.5
https://github.com/lydonchandra/TOCWidget/zipball/v2.5
https://github.com/lydonchandra/TOCWidget/commit/856679aae0f0e5789ad9c961a76bd6061d69b3c3

For TOCWidget version 2.4
https://github.com/lydonchandra/TOCWidget/zipball/v2.4
https://github.com/lydonchandra/TOCWidget/commit/2a61e2d91703ba53f8c249e0eba3cae3b118de38


Original Readme.txt :

This is my TOC/Legend widget for Flex Viewer 2.5
Initial Release: 12-1-2010

*****************************************************************************************************************************************
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!  READ THIS !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*
*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*
*																	*
* MAJOR CHANGE in this 2.5 version of the TOC Widget											*
* You CAN NOT use this widget with the LayerListWidget and or MapSwitcherWidget with the layerlist visible="true" 			*
* Although it will function layer reordering with may throw errors as synchronizing between map layer reorders has issues		*
*																	*
* This version of the TOC Widget is dependent on several new AppEvents that were added in Flex Viewer 2.5				*
* So this means YOU CAN NOT USE THIS VERSION UNLESS YOU ARE RUNNING FLEX VIEWER 2.5!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!		*
*																	*
* It is your responsibility to disable the layerlist portion of the MapSwitcherWidget or eMapSwitcherWidget by setting the		* 
* <layerlist visible="false">														*
* Also ensure you do not use the TOCWidget with the LayerListWidget.									*
*																	*
*****************************************************************************************************************************************

Version 2.5 - 12 Dec, 2011
* Added new Flex Viewer 2.5 Layer menu capability to TOC.
* Enhanced the visual appearance of the out of the box Flex Viewer 2.5 Layer options menu and added more options.

Version 2.4.5 - 9 Nov, 2011
* Fix changes to label in xml file not being honored.

Version 2.4.5 - 9 Nov, 2011
* Fix changes to label in xml file not being honored.

Version 2.4.4 - 22 Sept, 2011
* Fix for PictureMarkerSymbols comming from a 10.0 Server.

Version 2.4.3 - 2 Sept, 2011
* Fix for WMS and Image Services constantly displaying the generating legends message.
* Fix for scale dependent layers label not being readable when end user is using white as widget
  background color.

Version 2.4.2 - 1 August, 2011, 8:40 PM
* Fix for the disappearing labels
* TOCWidget now respects what has been set in the MapSwitcherWidget and vise versa.
* Minimal support for KML layers has been added. Legend swatches are not supported yet as the 
  API's support of KMLLayer is not matured yet.
* Uncompiled code is written for Flex Viewer 2.4 ONLY!

Version 2.3.9.2 - 1 August, 2011, 8:40 PM
* This probably will not happen ever again but I wanted to have a good stable Flex Viewer 2.3.1 
  version of this widget available so I have added the compiled version with the memory leak fix 
  and the follow-up fix for the disapearing labels.
* Uncompiled code is written for Flex Viewer 2.4 ONLY!

Version 2.4.1 - 1 August, 2011, 3:10PM
* Fixed memory leak issue
* added back in the 2.3.1 compiled version since I have such a grievous code error, for those that have not yet updated to the Flex Viewer 2.4.
* Fixed issue with REALLY long layer labels and placement of the Details button.

Version 2.4 - 29 July, 2011
* Recompiled for Flex Viewer 2.4

Version 2.3.9.1 - 19 July, 2011
* Fixed a item alignment issue in the TOC

Version 2.3.9 - 12 July, 2011
* Added exit code for people still using ArcGIS Server 9.3.1 or lower so that the Generating Legends
  message was not be stuck on the widget. (Lengend swatches will not be gerated for Server 9.3.1 or lower).

Version 2.3.8.6 - 6 July, 2011
* Added Ability to collapse ALL legend symbology 
* Added new context menu for "expand all layers" and "collapse all layers"
* Changed the expand and contract icon for legends to the plus and minus (like in ArcMap).

Version 2.3.8.5 - 1 July, 2011
* Added Ability to collapse legend symbology is more than one symbol is present for a layer
* Added ability to have all collapsible legend symbology collapsed at startup based on 
  TOCWidget.xml setting.

Version 2.3.8.4 - 23 June, 2011
* Slowed down mouse wheel scroll speed
* Added generic legend support for Dimension, Annotation, Raster Catalog, and Tiled Raster Basemaps
* I am not real happy with the Tiled Raster Basemaps but the way esri currently returns legend info
  is not real conducive to legend generation. Maybe 10.1 of server will fix this.

Version 2.3.8.3 - 21 June, 2011
* Fixed issue with excluding multiple sublayers of a dynamic map service.
* Added a busy indicator and message for large complicated legends.

Version 2.3.8.2 - 21 June, 2011
* More optimization of the layout to use less vertical and horizontal space.

Version 2.3.8.1 - 20 June, 2011
* Fixed Horizontal clipping issues when tree leafs were collapsed.

Version 2.3.8 - 11 June, 2011
* Fixed Horizontal and vertical scrolling issues.
* Enhanced layout of TOC swatches and checkboxes.
* Cleaned up lots of unused portions of the code.
* TOC Item label is gray when item is scale dependent.

Version 2.3.7.2 - 10 June, 2011
* Fixed ZoomToMakeVisible context menu when using cached/tiled base maps.
* Feature layers now only have one checkbox at the parent map service that show
  Scale dependency and has context menus.

Version 2.3.7.1 - 9 June, 2011
* Fixed Scale Dependent Checkbox Icon.
* Depreciated TOC updates from programmatic changes to layer visibility due to issues with this code.

Version 2.3.7 - 9 June, 2011
* Fixed some more TOC Swatch rendering issues.
* TOC now updates to programmatic changes to layer visibility.

Version 2.3.6 - 8 June, 2011
* Fixed some TOC Swatch rendering issues
* Whole map services AND/OR INDIVIDUAL layers can be excluded from the toc AND STILL BE DRAWN ON THE MAP.

Version 2.3.5 - 7 June, 2011
* TOC and Legend are now merged.
* Feature Layers are handled more completely.
* If a layer only has on swatch than it is added next to the layer name saving space in the TOC.
* Metadata/Description for map services and layers are now shown in a custom sizable window instead
  of a alert dialog as previous version.
* Whole map services AND/OR INDIVIDUAL layers can be excluded from the TOC.
* The mx tree has about 99 bugs that are unresolved so there are some issues with scrolling the TOC
  and right click context menu operation. These a Adobe Flex SDK issues and cannot be resolved by me at this time.

Version 2.3.4 - 2 June, 2011
* Removed white background from legend.
* Added ability to exclude base maps from the legend (this is now the default).
* Verified that classified rasters are now supported if you are using ArcGIS Server SP1 or greater
* Set the legend timeout to 60 Seconds for those with slow servers (configurable in xml)
* Added better handling of layers that come from a slow server when it comes to building the legend
* Added ability to internationalize the text for transparency slider tooltip, layer details button tooltip,
  Context menus.
* Transparency/Opacity is now controlled by one slider at the top of the widget. You but select a map service
  in the TOC for it to become enabled.
* Added Zoom to Layer Extent context menu for individual map service layers
* Added Map Service description button and individual layer description and copyright alert when details button
 is pressed. Details button can be disabled in TOCWidget.xml

!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!  IMPORTANT ALL elements names in the TOCWidget.xml are now lowercase to stay with esri standards  !!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

Version 2.3.3 - 26 May, 2011
* Added tooltip to TOC Map Layers if the layer has a description and/or copyright.
* Fixed bug with legend getting cut off horizontally if labels are long.

Version 2.3.2 - 21 May, 2011
* Added back exclude layer from TOC capability.

Version 2.3.1 - 6 May, 2011
* Added support for legend generation whether you have ArcGIS Server 10 or 10 SP1
* Implemented other esri best practices.
* New version will no longer include compiled code for old versions of the viewer.

Version 2.2.2 - 26 January, 2011
* Added exclude layer support. This is WHOLE map service exclude capability ONLY
* Changed packaging of widget so that assets are included in widget folder for
easier moving of widget to new versions of the Flex Viewer.

Version 2.2.1
* Fixed issue with using the wrong code base for the FV2.2 compiled version 
and the uncompiled version. Exclude base maps and other options are back again.


Version 2.2
* Added a compiled version for both Flex Viewer 2.1 and 2.2

Version 2.1.1
* Fixed bug with uncompiled version where layerAlpha was looking
  for the widgetclosebuttonskin in the wrong place.

This is just a simple TOC Widget that includes my dynamic legend component.
This widget also includes my enhancement for map service transparency,
right click context menu for zoom to make layer visible, and my scale 
dependent renderer for the TOC checkboxes.

To install using the compiled version just copy the folder called TOC
under the Widgets folder, and add this line to your config.xml

<widget label="Map Contents" x="50" y="100"
				icon="assets/images/i_folder.png"
				config="widgets/TOC/TOCWidget.xml"
				url="widgets/TOC/TOCWidget.swf"/>

For the Uncompiled you need to copy the TOC folder to src/widgets then 
add TOCWidget.mxml to your flex projects modules list, and compile your
project as well as add the widget line above to your config.xml.


Enjoy
Robert Scheitlin
