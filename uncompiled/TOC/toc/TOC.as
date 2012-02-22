////////////////////////////////////////////////////////////////////////////////
//
// Copyright (c) 2010 ESRI
//
// All rights reserved under the copyright laws of the United States.
// You may freely redistribute and use this software, with or
// without modification, provided you include the original copyright
// and use restrictions.  See use restrictions in the file:
// <install location>/License.txt
//
////////////////////////////////////////////////////////////////////////////////
package widgets.TOC.toc
{

	import com.esri.ags.Map;
	import com.esri.ags.events.LayerEvent;
	import com.esri.ags.events.MapEvent;
	import com.esri.ags.layers.ArcGISDynamicMapServiceLayer;
	import com.esri.ags.layers.ArcGISTiledMapServiceLayer;
	import com.esri.ags.layers.FeatureLayer;
	import com.esri.ags.layers.GraphicsLayer;
	import com.esri.ags.layers.KMLLayer;
	import com.esri.ags.layers.Layer;
	import com.esri.ags.virtualearth.VETiledLayer;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Image;
	import mx.controls.Tree;
	import mx.controls.listClasses.IListItemRenderer;
	import mx.core.ClassFactory;
	import mx.core.FlexGlobals;
	import mx.core.ScrollPolicy;
	import mx.effects.Effect;
	import mx.effects.Fade;
	import mx.events.CollectionEvent;
	import mx.events.CollectionEventKind;
	import mx.events.ListEvent;
	
	import spark.components.HGroup;
	import spark.components.Scroller;
	
	import widgets.TOC.toc.tocClasses.TocItem;
	import widgets.TOC.toc.tocClasses.TocItemRenderer;
	import widgets.TOC.toc.tocClasses.TocMapLayerItem;
	import widgets.TOC.toc.utils.MapUtil;
	
	//--------------------------------------
	//  Other metadata
	//--------------------------------------
	
	/**
	 * A tree-based Table of Contents component for a Map.
	 */
	public class TOC extends Tree
	{
	    /**
	     * Creates a new TOC object.
	     *
	     * @param map The map that is linked to this TOC.
	     */
	    public function TOC(map:Map = null)
	    {
	        super();
			horizontalScrollPolicy = ScrollPolicy.OFF;
			verticalScrollPolicy = ScrollPolicy.OFF;
			variableRowHeight = true;
	        dataProvider = _tocRoots;
	        itemRenderer = new ClassFactory(widgets.TOC.toc.tocClasses.TocItemRenderer);
	        iconFunction = tocItemIcon;
	
	        map = map;
	
	        // Double click support for expanding/collapsing tree branches
	        doubleClickEnabled = true;
	        addEventListener(ListEvent.ITEM_DOUBLE_CLICK, onItemDoubleClick);
			FlexGlobals.topLevelApplication.addEventListener("legendDataLoaded$", legendDataLoadedHandler);
			FlexGlobals.topLevelApplication.addEventListener("legendDataLoaded2$", legendDataLoadedHandler2);
	
	        // Set default styles
	        setStyle("borderStyle", "none");
	    }
	
	    //--------------------------------------------------------------------------
	    //
	    //  Variables
	    //
	    //--------------------------------------------------------------------------
	
	    // The tree data provider
	    private var _tocRoots:ArrayCollection = new ArrayCollection(); // of TocItem
	
	    private var _map:Map;
	
	    private var _mapChanged:Boolean = false;
	
	    //toc style
	    private var _isMapServiceOnly:Boolean = false;
	
	    // Layer list filters
	    private var _includeLayers:ArrayCollection;
	
	    private var _excludeLayers:ArrayCollection;
	
	    private var _excludeGraphicsLayers:Boolean = false;
	
	    private var _layerFiltersChanged:Boolean = false;
	
	    // Label function for TocMapLayerItem
	    private var _labelFunction:Function = null;
	
	    private var _labelFunctionChanged:Boolean = false;
	
	    // The effect used on layer show/hide
	    private var _fade:Effect;
	
	    private var _fadeDuration:Number = 250; // milliseconds
	
	    private var _useLayerFadeEffect:Boolean = false;
	
	    private var _useLayerFadeEffectChanged:Boolean = false;
		
		private var _metadataToolTip:String = "";
		
		private var _showMetadataButton:Boolean;
		
		private var _expanded:Boolean;
		
		private var _legendCollapsed:Boolean;
		
		private var _tocMinWidth:Number = 300;
		
		private var _scroller:Scroller = null;
		
		private var lLoader:HGroup = null;
		
		private var numOfLayers:Number = 0;
	
	    //--------------------------------------------------------------------------
	    //  Property:  map
	    //--------------------------------------------------------------------------
	
	    [Bindable("mapChanged")]
	    /**
	     * The Map to which this TOC is attached.
	     */
	    public function get map():Map
	    {
	        return _map;
	    }
	
	    /**
	     * @private
	     */
	    public function set map(value:Map):void
	    {
	        if (value != _map)
	        {
	            removeMapListeners();
	            _map = value;
	            addMapListeners();
	
	            _mapChanged = true;
	            invalidateProperties();
	
	            dispatchEvent(new Event("mapChanged"));
	        }
	    }
	
	    [Bindable("mapServiceOnlyChanged")]
	    public function get isMapServiceOnly():Boolean
	    {
	        return _isMapServiceOnly;
	    }
		
		override protected function mouseOverHandler(event:MouseEvent):void 
		{
			var item:TocItem = mouseEventToItemRenderer(event).data as TocItem;
			if (item != null && item.label != "dummy") 
			{
				super.mouseOverHandler(event);
			}
		}
		
		override protected function mouseDownHandler(event:MouseEvent):void 
		{
			var item:TocItem = mouseEventToItemRenderer(event).data as TocItem;
			if (item != null && item.label != "dummy") 
			{
				super.mouseDownHandler(event);
			}
		}
	
	    public function set isMapServiceOnly(value:Boolean):void
	    {
	        _isMapServiceOnly = value;
	        dispatchEvent(new Event("mapServiceOnlyChanged"));
	    }
	
	    //--------------------------------------------------------------------------
	    //  Property:  includeLayers
	    //--------------------------------------------------------------------------
	
	    [Bindable("includeLayersChanged")]
	    /**
	     * A list of layer objects and/or layer IDs to include in the TOC.
	     */
	    public function get includeLayers():Object
	    {
	        return _includeLayers;
	    }
	
	    /**
	     * @private
	     */
	    public function set includeLayers(value:Object):void
	    {
	        removeLayerFilterListeners(_includeLayers);
	        _includeLayers = normalizeLayerFilter(value);
	        addLayerFilterListeners(_includeLayers);
	        onFilterChange();
	        dispatchEvent(new Event("includeLayersChanged"));
	    }
	
	    //--------------------------------------------------------------------------
	    //  Property:  excludeLayers
	    //--------------------------------------------------------------------------
	
	    [Bindable("excludeLayersChanged")]
	    /**
	     * A list of layer objects and/or layer IDs to exclude from the TOC.
	     */
	    public function get excludeLayers():Object
	    {
	        return _excludeLayers;
	    }
	
	    /**
	     * @private
	     */
	    public function set excludeLayers(value:Object):void
	    {
	        removeLayerFilterListeners(_excludeLayers);
	        _excludeLayers = normalizeLayerFilter(value);
	        addLayerFilterListeners(_excludeLayers);
	
	        onFilterChange();
	        dispatchEvent(new Event("excludeLayersChanged"));
	    }
	
	    //--------------------------------------------------------------------------
	    //  Property:  excludeGraphicsLayers
	    //--------------------------------------------------------------------------
	
	    [Bindable]
	    [Inspectable(category="Mapping", defaultValue="false")]
	    /**
	     * Whether to exclude all GraphicsLayer map layers from the TOC.
	     *
	     * @default false
	     */
	    public function get excludeGraphicsLayers():Boolean
	    {
	        return _excludeGraphicsLayers;
	    }
	
	    /**
	     * @private
	     */
	    public function set excludeGraphicsLayers(value:Boolean):void
	    {
	        _excludeGraphicsLayers = value;
	
	        onFilterChange();
	    }
	
	    //--------------------------------------------------------------------------
	    //  Property:  labelFunction
	    //--------------------------------------------------------------------------
	
	    /**
	     * A label function for map layers.
	     *
	     * The function signature must be: <code>labelFunc( layer : Layer ) : String</code>
	     */
	    override public function set labelFunction(value:Function):void
	    {
	        // CAUTION: We are overriding the semantics and method signature of the
	        //   super Tree's labelFunction, so do not set the super.labelFunction property.
	        //
	        //   Also, we must reference the function using "_labelFunction" instead of
	        //   "labelFunction" since the latter will call the getter method on Tree,
	        //   rather than grabbing this TOC's instance variable.
	
	        _labelFunction = value;
	
	        _labelFunctionChanged = true;
	        invalidateProperties();
	    }
		
		//--------------------------------------------------------------------------
		//  Property:  showMetadata
		//--------------------------------------------------------------------------
		
		public function set showMetadataButton(value:Boolean):void
		{
			_showMetadataButton = value;
		}
		
		//--------------------------------------------------------------------------
		//  Property:  tocMinWidth
		//--------------------------------------------------------------------------
		
		public function set tocMinWidth(value:Number):void
		{
			_tocMinWidth = value;
		}
		
		//--------------------------------------------------------------------------
		//  Property:  scroller
		//--------------------------------------------------------------------------
		
		public function set scroller(value:Scroller):void
		{
			_scroller = value;
		}
		
		//--------------------------------------------------------------------------
		//  Property:  loader
		//--------------------------------------------------------------------------
		
		public function set loader(value:HGroup):void
		{
			lLoader = value;
		}
	
	    //--------------------------------------------------------------------------
	    //  Property:  useLayerFadeEffect
	    //--------------------------------------------------------------------------
	
	    [Bindable("useLayerFadeEffectChanged")]
	    [Inspectable(category="Mapping", defaultValue="false")]
	    /**
	     * Whether to use a Fade effect when the map layers are shown or hidden.
	     *
	     * @default false
	     */
	    public function get useLayerFadeEffect():Boolean
	    {
	        return _useLayerFadeEffect;
	    }
	
	    /**
	     * @private
	     */
	    public function set useLayerFadeEffect(value:Boolean):void
	    {
	        if (value != _useLayerFadeEffect)
	        {
	            _useLayerFadeEffect = value;
	
	            _useLayerFadeEffectChanged = true;
	            invalidateProperties();
	
	            dispatchEvent(new Event("useLayerFadeEffectChanged"));
	        }
	    }
	
	    /**
	     * @private
	     */
	    override protected function commitProperties():void
	    {
	        super.commitProperties();
	
	        if (_mapChanged || _layerFiltersChanged || _labelFunctionChanged)
	        {
	            _mapChanged = false;
	            _layerFiltersChanged = false;
	            _labelFunctionChanged = false;
	
	            // Repopulate the TOC data provider
	            registerAllMapLayers();
	        }
	
	        if (_useLayerFadeEffectChanged)
	        {
	            _useLayerFadeEffectChanged = false;
	
	            MapUtil.forEachMapLayer(map, function(layer:Layer):void
	            {
	                setLayerFadeEffect(layer);
	            });
	        }
	    }
	
	    private function addMapListeners():void
	    {
	        if (map)
	        {
	            map.addEventListener(MapEvent.LAYER_ADD, onLayerAdd, false, 0, true);
	            map.addEventListener(MapEvent.LAYER_REMOVE, onLayerRemove, false, 0, true);
	            map.addEventListener(MapEvent.LAYER_REMOVE_ALL, onLayerRemoveAll, false, 0, true);
	            map.addEventListener(MapEvent.LAYER_REORDER, onLayerReorder, false, 0, true);
	        }
	    }
	
	    private function removeMapListeners():void
	    {
	        if (map)
	        {
	            map.removeEventListener(MapEvent.LAYER_ADD, onLayerAdd);
	            map.removeEventListener(MapEvent.LAYER_REMOVE, onLayerRemove);
	            map.removeEventListener(MapEvent.LAYER_REMOVE_ALL, onLayerRemoveAll);
	            map.removeEventListener(MapEvent.LAYER_REORDER, onLayerReorder);
	        }
	    }
	
	    /**
	     * Registers the new map layer in the TOC tree.
	     */
	    private function onLayerAdd(event:MapEvent):void
	    {
	        registerMapLayer(event.layer);
	    }
	
	    private function onLayerRemove(event:MapEvent):void
	    {
	        unregisterMapLayer(event.layer);
	    }
	
	    private function onLayerRemoveAll(event:MapEvent):void
	    {
	        unregisterAllMapLayers();
	    }
	
		private function onLayerReorder(event:MapEvent):void
		{
			const layer:Layer = event.layer;
			const index:int = event.index;
			
			for (var i:int = 0; i < _tocRoots.length; i++)
			{
				const item:Object = _tocRoots[i];
				if (item is TocMapLayerItem && TocMapLayerItem(item).layer === layer)
				{
					_tocRoots.removeItemAt(i);
					_tocRoots.addItemAt(item, _tocRoots.length - index - 1);
					break;
				}
			}
		}
	
	    private function unregisterAllMapLayers():void
	    {
	        _tocRoots.removeAll();
	    }
	
	    private function unregisterMapLayer(layer:Layer):void
	    {
	        for (var i:int = 0; i < _tocRoots.length; i++)
	        {
	            var item:Object = _tocRoots[i];
	            if (item is TocMapLayerItem && TocMapLayerItem(item).layer === layer)
	            {
	                _tocRoots.removeItemAt(i);
	                break;
	            }
	        }
	    }
	
	    /**
	     * Registers all existing map layers in the TOC tree.
	     */
	    private function registerAllMapLayers():void
	    {
	        unregisterAllMapLayers();
			
			var gl:GraphicsLayer = new GraphicsLayer();
			gl.id="dummy";
			gl.name="dummy";
			registerMapLayer(gl);
			
	        MapUtil.forEachMapLayer(map, function(layer:Layer):void
	        {
	            registerMapLayer(layer);
	        });
	    }
	
	    /**
	     * Creates a new top-level TOC item for the specified map layer.
	     */
	    private function registerMapLayer(layer:Layer):void
	    {
			if(layer.name != "dummy"){
		        if (filterOutSubLayer(layer))
		        {
		            //trace("Filtering out TOC layer '" + layer.id + "'");
		            return;
		        }
			}
			lLoader.visible = lLoader.includeInLayout = true;
			numOfLayers += 1;
			if(layer is VETiledLayer || layer.name == "dummy" || (layer is KMLLayer && !layer.visible))
				numOfLayers -= 1;
	
	        // Init any layer properties, styles, and effects
	        if (useLayerFadeEffect)
	        {
	            setLayerFadeEffect(layer);
	        }
	
	        // Add a new top-level TOC item at the beginning of the list (reverse rendering order)
	        const tocItem:TocMapLayerItem = new TocMapLayerItem(layer, _labelFunction, _isMapServiceOnly, _excludeLayers, _showMetadataButton, _legendCollapsed);
			
			tocItem.scroller = _scroller;
			tocItem.tocMinWidth = _tocMinWidth;
			tocItem.metatooltip = _metadataToolTip;
			
			var ready:Boolean = true;
			if(_showMetadataButton){
				if (layer is ArcGISTiledMapServiceLayer) {
					tocItem.ttooltip = ArcGISTiledMapServiceLayer(layer).serviceDescription;
				} else if (layer is ArcGISDynamicMapServiceLayer) {
					tocItem.ttooltip = ArcGISDynamicMapServiceLayer(layer).serviceDescription;
				} else if (layer is KMLLayer) {
					tocItem.ttooltip = KMLLayer(layer).description;
				} else if (layer is FeatureLayer) {
					var msName:String = FeatureLayer(layer).url.replace("FeatureServer","MapServer");
					if(msName.substring(msName.length - 9) != "MapServer")
					{
						var arc:ArcGISDynamicMapServiceLayer = new ArcGISDynamicMapServiceLayer(msName.substring(0,msName.lastIndexOf("/")));
						if(arc.loaded){
							tocItem.ttooltip = arc.serviceDescription
						}else{
							ready = false;
							arc.addEventListener(LayerEvent.LOAD, 
								function(event:LayerEvent):void{
									tocItem.ttooltip = ArcGISDynamicMapServiceLayer(event.layer).serviceDescription;
									_tocRoots.addItemAt(tocItem, 0);
									if(_expanded) expandItem(tocItem, true, true, false, null);
								});
						}
					}
				}
			}
	        if(ready){
				_tocRoots.addItemAt(tocItem, 0);
				if(_expanded) expandItem(tocItem, true, true, false, null);
			}
	    }
	
	    private function setLayerFadeEffect(layer:Layer):void
	    {
	        if (useLayerFadeEffect)
	        {
	            // Lazy load the effect
	            if (!_fade)
	            {
	                _fade = new Fade();
	                _fade.duration = _fadeDuration;
	            }
	            layer.setStyle("showEffect", _fade);
	            layer.setStyle("hideEffect", _fade);
	        }
	        else
	        {
	            layer.clearStyle("showEffect");
	            layer.clearStyle("hideEffect");
	        }
	    }
	
	    private function addLayerFilterListeners(filter:ArrayCollection):void
	    {
	        if (filter)
	        {
	            filter.addEventListener(CollectionEvent.COLLECTION_CHANGE, onFilterChange, false, 0, true);
	        }
	    }
	
	    private function removeLayerFilterListeners(filter:ArrayCollection):void
	    {
	        if (filter)
	        {
	            filter.removeEventListener(CollectionEvent.COLLECTION_CHANGE, onFilterChange);
	        }
	    }
	
	    private function onFilterChange(event:CollectionEvent = null):void
	    {
	        var isValidChange:Boolean = false;
	
	        if (event == null)
	        {
	            // Called directly from the setters
	            isValidChange = true;
	        }
	        else
	        {
	            // Only act on certain kinds of collection changes.
	            // Specifically, avoid acting on the UPDATE kind.
	            // It causes unwanted refresh of the TOC model.
	            switch (event.kind)
	            {
	                case CollectionEventKind.ADD:
	                case CollectionEventKind.REMOVE:
	                case CollectionEventKind.REPLACE:
	                case CollectionEventKind.REFRESH:
	                case CollectionEventKind.RESET:
	                {
	                    isValidChange = true;
	                }
	            }
	        }
	
	        if (isValidChange)
	        {
	            _layerFiltersChanged = true;
	            invalidateProperties();
	        }
	    }
		
		
		private function filterOutSubLayer(layer:Layer, id:int = -1):Boolean
		{
			var exclude:Boolean = false;
			if (excludeGraphicsLayers && layer is GraphicsLayer && !(layer is FeatureLayer))
			{
				exclude = true;
			}
			if (!exclude && excludeLayers) {
				exclude = false;
				for each (var item:* in excludeLayers) {
					var iArr:Array = item.ids?item.ids:new Array;
					var index:int = iArr.indexOf(id.toString());
					if (item.name == layer.id || item.name == layer.name){
						if(index >= 0 || iArr.length == 0)
						{
							exclude = true;
							break;
						}
					}
				}
			}
			return exclude;
		}
	
	    private function filterOutLayer(layer:Layer):Boolean
	    {
	        var exclude:Boolean = false;
	        if (excludeGraphicsLayers && layer is GraphicsLayer && !(layer is FeatureLayer))
	        {
	            exclude = true;
	        }
	        if (!exclude && excludeLayers)
	        {
	            exclude = false;
	            for each (var item:* in excludeLayers)
	            {
	                if ((item === layer || item == layer.name) || (item == layer.id))
	                {
	                    exclude = true;
	                    break;
	                }
	            }
	        }
	        if (includeLayers)
	        {
	            exclude = true;
	            for each (item in includeLayers)
	            {
	                if (item === layer || item == layer.id)
	                {
	                    exclude = false;
	                    break;
	                }
	            }
	        }
	        return exclude;
	    }
	
	    private function normalizeLayerFilter(value:Object):ArrayCollection
	    {
	        var filter:ArrayCollection;
	        if (value is ArrayCollection)
	        {
	            filter = value as ArrayCollection;
	        }
	        else if (value is Array)
	        {
	            filter = new ArrayCollection(value as Array);
	        }
	        else if (value is String || value is Layer)
	        {
	            // Possibly a String (layer id) or Layer object
	            filter = new ArrayCollection([ value ]);
	        }
	        else
	        {
	            // Unsupported value type
	            filter = null;
	        }
	        return filter;
	    }
	
	    /**
	     * Double click handler for expanding or collapsing a tree branch.
	     */
	    private function onItemDoubleClick(event:ListEvent):void
	    {
	        if (event.itemRenderer && event.itemRenderer.data)
	        {
	            var item:Object = event.itemRenderer.data;
	            expandItem(item, !isItemOpen(item), true, true, event);
	        }
	    }		
	
	    private function tocItemIcon(item:Object):Class
	    {
	        return null;
	    }
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			width = measureWidthOfItems();
			height = measureHeightOfItems();
			
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		//Added to set the tooltips for item buttons
		public function set metadataToolTip(value:String):void
		{
			_metadataToolTip = value;
		}
		
		public function set expanded(value:Boolean):void
		{
			_expanded = value;
		}
		
		public function set legendCollapsed(value:Boolean):void
		{
			_legendCollapsed = value;
		}
		
		private function legendDataLoadedHandler2(event:Event):void
		{
			_tocRoots.refresh();
		}
		
		private function legendDataLoadedHandler(event:Event):void
		{
			_tocRoots.refresh();
			
			numOfLayers -= 1;
			if (numOfLayers == 0)
				lLoader.visible = lLoader.includeInLayout = false;
		}
	}
}