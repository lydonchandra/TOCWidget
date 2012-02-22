////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2011 Esri
//
// All rights reserved under the copyright laws of the United States.
// You may freely redistribute and use this software, with or
// without modification, provided you include the original copyright
// and use restrictions.  See use restrictions in the file:
// <install location>/License.txt
//
////////////////////////////////////////////////////////////////////////////////
package widgets.TOC.toc.tocClasses
{

	import com.esri.ags.layers.KMLLayer;
	import com.esri.ags.layers.supportClasses.KMLFeatureInfo;
	import com.esri.ags.layers.supportClasses.KMLFolder;
	
	import com.esri.ags.events.ExtentEvent;
	import com.esri.ags.geometry.Extent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.system.LoaderContext;
	import flash.utils.ByteArray;
	
	import mx.containers.HBox;
	import mx.containers.VBox;
	import mx.controls.Image;
	import mx.core.FlexGlobals;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	import mx.utils.Base64Decoder;
	
	import spark.components.Group;
	import spark.components.HGroup;
	import spark.components.Label;
	import spark.components.VGroup;
	import spark.primitives.BitmapImage;
	import com.esri.viewer.ViewerContainer;
	
	/**
	 * A TOC item representing a NetworkLink within a KML Layer.
	 */
	public class TocKmlNetworkLinkItem extends TocItem
	{
	    public function TocKmlNetworkLinkItem(parentItem:TocItem, networkLink:KMLLayer, layer:KMLLayer)
	    {
	        super(parentItem);
	
	        _networkLink = networkLink;
	        _layer = layer;
	        label = networkLink.name;
	
	        setVisible(networkLink.visible, false);
			
			ViewerContainer.getInstance().mapManager.map.addEventListener(ExtentEvent.EXTENT_CHANGE,checkExtent);
	    }
	
	    //--------------------------------------------------------------------------
	    //  Property:  folder
	    //--------------------------------------------------------------------------
	
	    private var _networkLink:KMLLayer;
	
	    /**
	     * The KML Folder that represents this TOC item.
	     */
	    public function get networkLink():KMLLayer
	    {
	        return _networkLink;
	    }
	
	    //--------------------------------------------------------------------------
	    //  Property:  layer
	    //--------------------------------------------------------------------------
	
	    private var _layer:KMLLayer;
	
	    /**
	     * The KML layer associated with this TOC item.
	     */
	    public function get layer():KMLLayer
	    {
	        return _layer;
	    }
		
		internal static const DEFAULT_MAX:Number = 0;
		
		private var _maxScale:Number = DEFAULT_MAX;
		
		public function set maxScale( value:Number ):void
		{
			_maxScale = value;
			this.scaledependant = true;
			
			if(_maxScale > 0 && _minScale > 0){
				if ((ViewerContainer.getInstance().mapManager.map.scale >= _maxScale) &&
					(ViewerContainer.getInstance().mapManager.map.scale <= _minScale)){
					this.scaledependant = false;
				}			
			} else if (_maxScale > 0 ){
				if ((ViewerContainer.getInstance().mapManager.map.scale >= _maxScale)){
					this.scaledependant = false;
				}
			} else if (_minScale > 0 ) {
				if ((ViewerContainer.getInstance().mapManager.map.scale <= _minScale)){
					this.scaledependant = false;
				}
			} else {
				this.scaledependant = false;
			}
		}
		
		public function get maxScale():Number
		{
			return _maxScale;
		}
		
		private function checkExtent(evt:ExtentEvent):void{
			this.scaledependant = true;
			
			if(_maxScale > 0 && _minScale > 0){
				if ((ViewerContainer.getInstance().mapManager.map.scale >= _maxScale) &&
					(ViewerContainer.getInstance().mapManager.map.scale <= _minScale)){
					this.scaledependant = false;
				}			
			} else if (_maxScale > 0 ){
				if ((ViewerContainer.getInstance().mapManager.map.scale >= _maxScale)){
					this.scaledependant = false;
				}
			} else if (_minScale > 0 ) {
				if ((ViewerContainer.getInstance().mapManager.map.scale <= _minScale)){
					this.scaledependant = false;
				}
			} else {
				this.scaledependant = false;
			}
		}
		
		private function getTocMapItem(tocItem:TocItem):TocMapLayerItem
		{
			const tocMapItem:TocMapLayerItem = tocItem as TocMapLayerItem;
			if (tocMapItem)
			{
				return tocMapItem;
			}
			if (tocItem.parent)
			{
				return getTocMapItem(tocItem.parent);
			}
			return null;
		}
		
		internal static const DEFAULT_MIN:Number = 0;
		
		private var _minScale:Number = DEFAULT_MIN;
		
		public function set minScale( value:Number ):void
		{
			_minScale = value;
			this.scaledependant = true;
			
			if(_maxScale > 0 && _minScale > 0){
				if ((ViewerContainer.getInstance().mapManager.map.scale >= _maxScale) &&
					(ViewerContainer.getInstance().mapManager.map.scale <= _minScale)){
					this.scaledependant = false;
				}			
			} else if (_maxScale > 0 ){
				if ((ViewerContainer.getInstance().mapManager.map.scale >= _maxScale)){
					this.scaledependant = false;
				}
			} else if (_minScale > 0 ) {
				if ((ViewerContainer.getInstance().mapManager.map.scale <= _minScale)){
					this.scaledependant = false;
				}
			} else {
				this.scaledependant = false;
			}
		}
		
		public function get minScale():Number
		{
			return _minScale;
		}
		
		internal static const DEFAULT_EXT:Extent = new Extent();
		
		private var _layerExtent:Extent = DEFAULT_EXT;
		
		public function set layerExtent( value:Extent ):void
		{
			_layerExtent = value;
		}
		
		public function get layerExtent():Extent
		{
			return _layerExtent;
		}
	
	    //--------------------------------------------------------------------------
	    //
	    //  Methods
	    //
	    //--------------------------------------------------------------------------
	
	    /**
	     * @private
	     */
	    override internal function setVisible(value:Boolean, layerRefresh:Boolean = true):void
	    {
	        // Set the visible state of this item, but defer the folder refresh on the layer
	        super.setVisible(value, false);
	
	        if (layerRefresh)
	        {
	            networkLink.visible = value;
	            if (value)
	            {
	                if (parent is TocKmlFolderItem)
	                {
	                    networkLink.visible = isNetworkLinkVisibileBasedOnParentFolder();
	                }
	            }
	        }
	    }
	
	    private function isNetworkLinkVisibileBasedOnParentFolder():Boolean
	    {
	        var result:Boolean;
	
	        // find the immediate parent folder
	        var parentFolder:KMLFolder = TocKmlFolderItem(parent).folder;
	        result = parentFolder.visible;
	        if (parentFolder.visible)
	        {
	            var parents:Array = getParentFolders(parentFolder);
	            if (parents.length > 0)
	            {
	                for (var p:int = 0; p < parents.length; )
	                {
	                    if (!KMLFolder(parents[p]).visible)
	                    {
	                        result = false;
	                        break;
	                    }
	                    else
	                    {
	                        p++;
	                    }
	                }
	            }
	        }
	        return result;
	    }
	
	    private function getParentFolders(folder:KMLFolder, arr:Array = null):Array
	    {
	        if (!arr)
	        {
	            arr = [];
	        }
	
	        // Returns the parent folders ids of the given folder
	        var parentId:Number = folder.parentFolderId;
	
	        if (parentId != -1)
	        {
	            var kmlFeatureInfo:KMLFeatureInfo = new KMLFeatureInfo;
	            kmlFeatureInfo.type = KMLFeatureInfo.FOLDER;
	            kmlFeatureInfo.id = parentId;
	
	            var parentFolder:KMLFolder = layer.getFeature(kmlFeatureInfo) as KMLFolder;
				arr.push(parentFolder);
	            return getParentFolders(parentFolder, arr);
	        }
	        return arr;
	    }
		
		public function getImageResult():*
		{
			const tocMapItem:TocMapLayerItem = getTocMapItem(parent);
			const legendInfo:LegendDataItem = tocMapItem.getLegendDataByLayerName(_layer.id);
			if (legendInfo)
			{
				if (legendInfo.legendGroup.length == 1)
				{
					const legendClass:LegendDataClassItem = legendInfo.legendGroup[0];
					if(legendClass.image){
						return legendClass.image;
					}
					else if (legendClass.symbolitems.length == 1)
					{
						var lsi:LegendSymbolItem = legendClass.symbolitems[0];
						return lsi.uic;
					}
				}
			}
			return null;
		}
		
		public function addLegendClasses(vbox:VBox):void
		{
			const tocMapItem:TocMapLayerItem = getTocMapItem(parent);
			const legendInfo:LegendDataItem = tocMapItem.getLegendDataByLayerName(_layer.id);
			if (legendInfo)
			{
				if (legendInfo.legendGroup.length > 0)
				{
					for (var lc:int = 0; lc < legendInfo.legendGroup.length; lc++)
					{
						const legendClass:LegendDataClassItem = legendInfo.legendGroup[lc];
						if (legendClass.symbolitems.length > 1)
						{
							for each (var lsi:LegendSymbolItem in legendClass.symbolitems)
							{
								const hbox2:HBox = new HBox();
								hbox2.setStyle("horizontalGap", 2);
								hbox2.setStyle("verticalAlign", "middle");
								
								const lbl2:Label = new Label();
								lbl2.setStyle("fontWeight", "normal");
								
								lbl2.text = lsi.label;
								if(lsi.image){
									hbox2.addChild(lsi.image);
								}else{
									hbox2.addChild(lsi.uic);
								}
								hbox2.addChild(lbl2);
								vbox.addChild(hbox2);
							}
						}else if (legendInfo.legendGroup.length > 1){
							const hbox:HBox = new HBox();
							hbox.setStyle("horizontalGap", 2);
							hbox.setStyle("verticalAlign", "middle");
							
							const lbl:Label = new Label();
							lbl.setStyle("fontWeight", "normal");
							
							lbl.text = legendClass.label;
							hbox.addChild(legendClass.image);
							
							hbox.addChild(lbl);
							vbox.addChild(hbox);
						}
					}
				}
			}
		}
	}
}
