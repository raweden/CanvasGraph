//
// CGRender.j
// Core Canvas
//
// Created by Raweden.
// Copyright 2012 Raweden. All rights reserved.
//


//
// Road Map
//
// - This implementation could in the future be exchanged with a better one that utilizes WebGL.
//
// - TODO: add implementation for handling rendering of CAWebGLLayer layers.
//
// NOTES
//
// Most of the private and methods that does bridge creating resources will be refactored in the near future.
//


//
// Layer Attibutes that is of interest for the render.
//
// layer._superlayer = null;
// layer._sublayers;
// layer._frame;
// layer._bounds;
// layer._anchorPoint;
// layer._zPosition;
// layer._opacity;
// layer._hidden;
// layer._cornerRadius;
// layer._borderWidth;
// layer._backgroundColor;
// layer._shadow;
// layer._shouldRasterize;
// layer._rasterizationScale;
// layer._masksToBounds;
//
// This attributes needs backing in the render loop, and is to implement ASAP.
//
// layer._contents;
// layer._contentsCenter;
// layer._contentsGravity;
// layer._contentsRect;
// layer._contentsScale;
// layer._shadowPath;
//


@import "CABackingStore.j"
@import "Context2D.j"

//
// TODO
//
// TODO: this should be moved inside the render closure.
var _ratio = typeof devicePixelRatio !== 'undefined' ? devicePixelRatio : 1;
var _mainInvalidated = false;

if(typeof WeakMap == "undefined"){
    WeakMap = function WeakMap(){

        var _keys = [];
        var _values = [];

        this.get = function(key, defaultValue){
            var index = _keys.indexOf(key);
            if(index == -1){
                return defaultValue || undefined;
            }
            return _values[index];
        }

        this.set = function(key, value){
            var index = _keys.indexOf(key);
            if(index == -1){
                _keys.push(key);
                _values.push(value);
            }else{
                _values[index] = value;
            }
        }

        this.has = function(key){
            return _keys.indexOf(key) !== -1;
        }

        this.delete = function(key){
            var index = _keys.indexOf(key);
            if(index !== -1){
                _keys.splice(index,1);
                _values.splice(index,1);
            }
        }
    }
}


REMOVE_THIS_CLOSURE_VAR = (function(){

    // TODO: inside getBufferForView() there is a error is thrown when parent buffer cant be found.

    var exports = {};
    var _contextMap = new WeakMap();
    var _layerBuffers = new WeakMap();

    // variables that are related for requestAnimationFrame fallback.
    var _ticker = null;
    var _frameRate = 1000/40;   // default 40 fps.

    var defaultLayer = null;
    var nativeContext = null;

    var _dirtyLayers = [];
    // attributes related to the render loop.
    var _rendering = false;
    var currentContext = null;
    var currentLayer = null;

    // Debug
    var animationTime = -1;
    var drawTime = -1;
    var rasterizationTime = -1;
    //
    var _debug = true;
    var stats = {};     // contains render statistics.
    stats.frameRate = 0;
    stats.frameCount = 0;
    stats.lastUpdate = Date.now();
    stats.averageTime = -1;

    // TODO: this one could be improved.
    var onLoad = function(){
        var canvas = document.getElementById('root');
        var ctx = canvas.getContext('2d');
        bootstrap(ctx);
        window.removeEventListener('load', onLoad);
    }

    window.addEventListener('load', onLoad);

    /**
     *
     *
     */
    var bootstrap = function(ctx){

        // getting alternative vendor.
        var requestAnimationFrame = window.requestAnimationFrame || window.webkitRequestAnimationFrame || window.mozRequestAnimationFrame;

        nativeContext = ctx;
        allocateScreenLayer(ctx);

        // determine whether native render is available
        if(requestAnimationFrame){

            // native render loop using native requestAnimationFrame()
            var nativeRenderLoop = function(){
                mainRender();
                requestAnimationFrame(nativeRenderLoop);
            }

            // trigger the first render.
            requestAnimationFrame(nativeRenderLoop);
        }else{
            _ticker = new Timer(_frameRate, 0);
            _ticker.on('timer', mainRender);
            _ticker.start();
        }

    }

    // TODO: this one could be improved, using the CABackingStore.
    var allocateScreenLayer = function(ctx){
        nativeContext = ctx;
        var layer = objj_msgSend(objj_msgSend(CALayer, "alloc"), "init");
        autoResize(ctx);
        if(!defaultLayer){
            defaultLayer = layer;
            // temporary implementation.
            Object.defineProperty(window, 'defaultLayer', {get: function(){return defaultLayer;}});
        }else{
            // Multi-screen Content.
        }
    }

    var autoResize = function(ctx){
        var canvas = ctx.canvas;
        window.addEventListener("resize", function(){
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
            exports.render();
        });
        canvas.width = window.innerWidth;
        canvas.height = window.innerHeight;
    }

    var dequeCanvas = function(){

    }

    var enqueCanvas = function(ctx){

    }

    var getBackingStore = function(layer){

    }

    // Animation Frame

    var _animationFrames = [];  // array contaning callbacks.

    /**
     * Adds a callback for recursivly Refresning invalidated content.
     */
    exports.requestAnimationFrame = function(callback){
        var index = _animationFrames.indexOf(callback);

        if(index == -1){
            _animationFrames.push(callback);
        }
    }


    /**
     * Invokes all requested animation frame callbacks.
     */
    var dispatchAnimationFrame = function(){
        var frames = _animationFrames;
        _animationFrames = [];
        while(frames.length > 0 ){
            var callback = frames.pop();
            try{
                callback();
            }catch(e){
                // Better Do Nothing.
            }
        }
    }


    // Main Render Implementation


    /**
     *
     */
    exports.render = function(){
        if(!_rendering){
            _mainInvalidated = true;
            mainRender();
        }
    }

    /**
     * The Main on-screen rendering implementation.
     *
     * This method automaticly refresh and redraws invalidated layers.
     * It should never be invoked directly.
     */
    var mainRender = function(){

        // dispatches the enter frame event.
        _rendering = true;
        //
        animationTime = Date.now();
        dispatchAnimationFrame();
        animationTime = (Date.now() - animationTime);

        if(_mainInvalidated || _dirtyLayers.length > 0){
            drawTime = Date.now();
            renderRecursive();
            drawTime = (Date.now() - drawTime);

            // clears the whole canvas right before render.
            // @Todo could use some improvement here, like dirty rectangles etc.
            var canvas = nativeContext.canvas;
            nativeContext.clearRect(0,0,canvas.width, canvas.height);

            // before doing any child rendering we need to call the super implementaton if this method..
            rasterizationTime = Date.now();
            renderLayerInContext(defaultLayer, nativeContext);
            rasterizationTime = (Date.now() - rasterizationTime);

            //_dirtyLayersLayers.length = 0;
            _mainInvalidated = false;
        }

        // render debug display if enabled.
        if(_debug){
            //drawLayerBounds(nativeContext, _rootWindow.layer,0,0,1,1);
            drawStatsInContext(nativeContext);
            // draws the buffers rectangles if enabled.
            if(false && _debugDrawBuffers){
                drawCanvasBuffer()
            }
            // draws the layers bounds if enabled..
            if(false && _debugDrawBounds){
                drawLayerBounds(ctx, defaultLayer, tx, ty, sx, sy)
            }
        }

        // resets the state of the rendering engine.
        _rendering = false;
    }


    // Recursivly Refresning invalidated content.


    /**
     * This method could be used for collecting dirty screen areas.
     * Where the dirty flash is set on the closted info object with
     * its own off-screen buffer. A array of invalidated buffers could
     * be provided.
     */
    var renderRecursive = function(){

        // swaping array which flags dirty views, this prevents eternal render loops.
        var dirty = _dirtyLayers;

        _dirtyLayers = [];
        while(dirty.length > 0){
            var layer = dirty.shift();
            var view = objj_msgSend(layer, "delegate");

            if(layer._hidden){
                continue;
            }

            // for now we just call this anyways.
            // @Todo better flagging system need to be implemented
            // @Todo should use view.layoutIfNeeded and then after this loop make
            //       a secound pass to draw the rest, or call this in an another loop before.

            objj_msgSend(view, "layoutIfNeeded");

            currentLayer = layer;
            objj_msgSend(view, "drawRect:");
            currentLayer = null;

            /*var buffer = null; //getBufferForView(view,context);
            if(buffers.indexOf(buffer) == -1){
                buffers.push(buffer);
            }*/
        }
    }

    /**
     * Returns the rendering context for the current layer.
     *
     * @return {Context2D} A Context2D object.
     */
    getCurrentContext = function(){
        if(!_rendering || !currentLayer){
            throw new Error("This method should not be invoked outside drawRect");
            return currentContext;
        }else{
            var ctx = _contextMap.get(currentLayer);
            if(!ctx){
                ctx = new Context2D();
                _contextMap.set(currentLayer, ctx);
            }
            return ctx;
        }
        return null;
    }


    // Layer Invalidation


    exports.flagLayerAsDirty = function(layer){
        var index = _dirtyLayers.indexOf(layer);
        if(index == -1){
            _dirtyLayers.push(layer);
            _mainInvalidated = true;
        }
    }


    // Layer Composition


    /**
     * Renders the Layer and it's sublayers onto the canvas context.
     *
     * @param  {Array} layer A array of CALayer instances.
     * @param  {CanvasRenderingContext2D} ctx The native rendering context.
     */
    var renderLayerInContext = function(layer, ctx){

        var frame = objj_msgSend(layer, "frame");
        if(!frame){
            console.log('frame may not be null!');
        }
        //console.log(layer);
        var bounds = objj_msgSend(layer, "bounds");
        var x = frame.origin.x;
        var y = frame.origin.y;
        var width = frame.size.width;
        var height = frame.size.height;
        var scale = layer.scale;
        var rotation = layer.rotation || 0;
        var anchorPoint = objj_msgSend(layer, "anchorPoint");
        var anchorX = 0;
        var anchorY = 0;
        if(anchorPoint){
            anchorX = anchorPoint.x;
            anchorY = anchorPoint.y;
        }
        //var isScrollLayer = objj_msgSend(layer, "isSubclassOfClass:", CAScrollLayer);
        //var scrollPoint =   //objj_msgSend(layer, "scrollPoint");;
        //var isGLLayer = objj_msgSend(layer, "isSubclassOfClass:", CAWebGLLayer);
        var scrollX = layer._scrollX;
        var scrollY = layer._scrollY;
        //
        var masksToBounds = objj_msgSend(layer, "masksToBounds");
        var opacity = objj_msgSend(layer, "opacity");
        var color = objj_msgSend(layer, "backgroundColor");
        var radius = objj_msgSend(layer, "cornerRadius");
        var hasRadius = typeof radius == 'number' && radius !== 0;
        //console.log('hasRadius: '+hasRadius);

        var rasterize = layer._shouldRasterize;

        // layer._superlayer;
        // layer._sublayers;
        // layer._frame;
        // layer._bounds;
        // layer._anchorPoint;
        // layer._zPosition;
        // layer._opacity;
        // layer._hidden;
        // layer._cornerRadius;
        // layer._borderWidth;
        // layer._backgroundColor;
        // layer._shadow;
        // layer._shouldRasterize;
        // layer._rasterizationScale;
        // layer._masksToBounds;

        x *= _ratio;
        y *= _ratio;

        ctx.save();
        ctx.translate(x, y);


        // setting scale transform if specified on the view.
        if (scale !== 1) {
            ctx.scale(scale, scale);
        }

        // setting rotation transform if specified on the view.
        if(rotation !== 0){
            ctx.rotate(rotation * (Math.PI / 180));
        }

        if(anchorX !== 0 || anchorY !== 0){

        }


        // setting global alpha transform if specified on the view.
        if(opacity !== 1){
            ctx.globalAlpha = opacity;
        }


        var ctx2d = _contextMap.get(layer);
        var buffer = _layerBuffers.get(layer);
        var sublayers = layer._sublayers;

        var translated = false;
        var len = sublayers.length;
        var sl; // reference to sub layer within drawing loop.
        var i;

        if(rasterize || buffer){
            var rasterizationScale = layer._rasterizationScale;
            var bufferWidth = width * _ratio;
            var bufferHeight = height * _ratio;
            if(rasterizationScale !== 1){
                bufferWidth = bufferWidth * rasterizationScale;
                bufferHeight = bufferHeight * rasterizationScale;
            }

            //
            // The behaivor of rasterization.
            //
            // When the value of this property is YES, the layer is rendered as
            // a bitmap in its local coordinate space and then composited to the
            // destination with any other content. Shadow effects and any
            // filters in the filters property are rasterized and included in
            // the bitmap. However, the current opacity of the layer is not
            // rasterized. If the rasterized bitmap requires scaling during
            // compositing, the filters in the minificationFilter and
            // magnificationFilter properties are applied as needed.
            //
            // When the value of this property is NO, the layer is composited
            // directly into the destination whenever possible. The layer may
            // still be rasterized prior to compositing if certain features of
            // the compositing model (such as the inclusion of filters) require
            // it.

            console.log("draws to buffer");

            // updating the buffers width and height (rasterization scale is taken into account).
            buffer.canvas.width = bufferWidth;
            buffer.canvas.height = bufferHeight;

            // clearing the buffers current content.
            buffer.clearRect(0, 0, bufferWidth, bufferHeight);


            // draws background color if set.
            if(color !== null){
                buffer.fillStyle = color.toString();
                buffer.fillRect(0, 0, bufferWidth, bufferHeight);
            }

            if(_layer.content){
                // handle layer.content here.
            }

            if(ctx2d){
                ctx.save();
                ctx2d.drawInNativeContext(buffer);
                ctx.restore();
            }

            if(scrollX !== 0 || scrollY !== 0){
                // Resolves the view's scrolling.
                buffer.save();
                translated = true;
                buffer.translate(-scrollX, -scrollY);
                //console.log('layer scrollX: '+scrollX+', scrollY: '+scrollY);
            }

            var needZ = shouldZOrder(sublayers);
            //console.log("CGRender:: " + layer + "needs z-order: "+ needZ);
            if(needZ){
                sublayers = getInZorder(sublayers);
            }
            // draws any child onto the same buffer.
            for (i = 0; i < len; i++) {
                sl = sublayers[i];

                if(sl._hidden || sl._opacity === 0){
                    continue;
                }

                // draws each child the buffer of it's parent.
                renderLayerInContext(sl, buffer);
            }

            if(translated){
                buffer.restore();
            }

            // draws the buffer onto the parent buffer.
            ctx.drawImage(buffer.canvas,0,0);

            //console.log("view render to buffer in " + (Date.now() - time) + "ms");

        }else{

            translated = ((scrollX && scrollX !== 0) || (scrollY && scrollY !== 0));

            //
            if(masksToBounds || hasRadius || translated){
                ctx.beginPath();
                if(hasRadius){
                    drawRoundRect(ctx, 0, 0, width, height, radius);
                }else{
                    ctx.rect(0, 0, width, height);
                }
                ctx.closePath();
                ctx.clip();
            }

            // draws background color if set.
            if(color !== null){
                ctx.fillStyle = color;
                ctx.fillRect(0, 0, width * _ratio, height * _ratio);
            }


            // Resolves the view's scrolling.
            if(translated){
                ctx.save();
                ctx.translate(-scrollX, -scrollY);
                translated = true;
                //console.log('layer scrollX: '+scrollX+', scrollY: '+scrollY);
            }

            if(ctx2d){
                ctx.save();
                ctx2d.drawInNativeContext(ctx);
                ctx.restore();
            }

            var needZ = shouldZOrder(sublayers);
            //console.log("CGRender:: " + layer + "needs z-order: "+ needZ);
            if(needZ){
                sublayers = getInZorder(sublayers);
            }

            for (i = 0; i < len; i++) {
                sl = sublayers[i];

                if(sl.hidden || sl.opacity === 0){
                    continue;
                }

                // draws each child
                renderLayerInContext(sl, ctx);
            }

            if(translated){
                ctx.restore();
            }
        }

        ctx.restore();
    };

    // Macro for creating a rounded rectangle path, used by renderLayerInContext()
    var drawRoundRect = function(ctx, x, y, width, height, radius){
        radius *= _ratio;

        var minx = x, midx = x + (width/2), maxx = x + width;
        var miny = y, midy = y + (height/2), maxy = y + height;
        // CGRectGetMinX, CGRectGetMidX, CGRectGetMaxX

        // pusing the drawing command into the command stack.
        // @Todo: Remove the beginPath() and closePath() calls
        ctx.moveTo(minx, midy);
        ctx.arcTo(minx, miny, midx, miny, radius);
        ctx.arcTo(maxx, miny, maxx, midy, radius);
        ctx.arcTo(maxx, maxy, midx, maxy, radius);
        ctx.arcTo(minx, maxy, minx, midy, radius);
    }

    // Debug Implementation

    /* This is not ideal.. TODO: refactor this implemention commented.
    CASetDebugFlag = function(flag, value){
        switch(flag){
            case "stats":

                break;
            case "buffers":

                break;
            case "bounds":

                break;
        }
    }

    CAClearAllDebugFlags = function(){

    }

    CAEnableDebug = function(){
        if(!_debug){
            _mainInvalidated = true;
            _debug = true;
        }
    }

    CADisableDebug = function(){
        if(_debug){
            _mainInvalidated = true;
            _debug = false;
        }

    }
    */

    /**
     * A boolean value that determine whether render statics should be shown.
     *
     * When set to true, a little informative frame is displayed in the top left
     * coner which displayes the frame-rate, average time spent on drawing and
     * the number of layers drawed.
     */
    Object.defineProperty(exports, 'debug', {
        set: function (value) {
            if(typeof value !== 'boolean'){
                throw new TypeError('.showStats expected boolean');
            }else if(value == _debug){
                return;
            }

            _debug = value;
            _mainInvalidated = true;
        },
        get: function(){
            return _debug;
        }
    });


    /**
     * Utility that measures average fps, this method also draws the stats onto the context.
     */
    var drawStatsInContext = function (ctx){
        var time = Date.now();

        var delta = time - stats.lastUpdate;

        if(delta >= 1000){
            stats.frameRate = stats.frameCount / (delta) * 1000;
            stats.lastUpdate = time;
            stats.frameCount = 0;
        }else{
            stats.frameCount++;
        }

        ctx.fillStyle = "#000000";
        ctx.fillRect(0, 0, 160, 42);

        ctx.font = "13pt Helvetica";
        ctx.fillStyle = "#FFFFFF";

        var fps = Math.round(stats.frameRate);
        var time = 0; //stats.averageTime.toFixed(0);

        var str = fps + " fps ~" + time + " ms";
        ctx.fillText(str, 5, 16);

        str = "a: " + animationTime + ", d: " + drawTime + ", r: "+ rasterizationTime;
        ctx.fillText(str, 5, 34);
        //str = "@ " + countViews(_rootWindow) + " views";
        //ctx.fillText(str, 5, 34);
    }

    var drawCanvasBuffers = function(){
        var ctx = defaultLayer;
    }



    /**
     * Utility method that draws the bounding boxes.
     */
    var drawLayerBounds = function(ctx, layer, tx, ty, sx, sy){

        var hidden = layer.hidden;

        if(hidden){
            ctx.strokeStyle = "#00FF00";
        }else{
            ctx.strokeStyle = "#FF0000";
        }

        tx = tx + (layer.x * sx);
        ty = ty + (layer.y * sy);

        sx = sx * layer.scale;
        sy = sy * layer.scale;

        var width = layer.width * sx;
        var height = layer.height * sy;

        ctx.strokeRect(tx + 0.5, ty + 0.5, width - 1, height - 1);

        if(hidden){
            return;
        }

        var layers = _layerMap.get(layer);
        var len = layers.length;

        if(len === 0){
            return;
        }

        if (len !== 0) {
            for (var i = 0; i < len; i++) {
                var sl = layers[i];
                drawLayerBounds(ctx, sl, tx, ty, sx, sy);
            }
        }
    }


    // Creating render buffers.


    /**
     * Creates a new canvas with the specified size and returns the 2D rendering context.
     * @return {CanvasRenderingContext2D}
     */
    exports.createGraphicsContext = function (width, height){
        var ctx = createContext2D();
        var canvas = ctx.canvas;
        canvas.width = width;
        canvas.height = height;
        return ctx;
    }

    // Creating Drawing Contextes.

    /**
     * Creates a new canvas and returns the web GL rendering context.
     * @return {WebGLRenderingContext}
     */
    var createWebGLContext = function(){
        var canvas = document.createElement('canvas');
        canvas.width = 320;
        canvas.height = 240;
        var ctx = canvas.getContext("webgl") || canvas.getContext("experimental-webgl");
        return ctx;
    }

    /**
     * Creates a new canvas and returns the 2D rendering context.
     * @return {CanvasRenderingContext2D}
     */
    var createContext2D = function(){
        var canvas = document.createElement('canvas');
        canvas.width =  320;
        canvas.height = 240;
        var ctx = canvas.getContext("2d");
        return ctx;
    }

    /**
     * Returns a boolean value that indicates whether the layers needs to be orderd by it's z position.
     *
     * @param  {Array} layers A array of CALayer subclasses.
     * @return {Boolean} A boolean `true` if the layers needs z-ordering. Otherwise `false`.
     */
    var shouldZOrder = function(layers){
        var len = layers.length;
        // we dont need to do this if the zero or one layer.
        if(len < 2){
            return false;
        }

        // preform a precheck to determine whether z odering is needed.
        for(var i = 0;i<len;i++){
            if(layers[i]._zPosition !== 0){
                return true;
            }
        }

        return false;
    }

    var getInZorder = function(layers){
        var len = layers.length;
        /*
        // we dont need to do this if the zero or one layer.
        if(len < 2){
            return layers;
        }
        // preform a precheck to determine whether z odering is needed.
        var i;
        var skip = true;
        for(var i = 0;i<len;i++){
            l = layers[i];
            var z = l._zPosition;
            if(l._zPosition !== 0){
                skip = false;
            }
        }

        if(skip){
            return layers;
        }
        */

        var l;          // layer.
        var sl = [];    // contains layer without specified z index.
        var m = {};     // map.
        var u = [];     // uniqe indexes.
        for(var i = 0;i<len;i++){
            l = layers[i];
            var z = l._zPosition;
            if(z === 0){
                sl.push(l);
                continue;
            }
            if(u.indexOf(z) == -1){
                m[z] = [l];
                u.push(z);
            }else{
                m[z].push(l);
            }
        }

        len = u.length;

        if(len == 0){
            return layers;
        }

        u.sort(function(a,b){return a - b;});

        for(var i = 0;i<len;i++){
            z = u[i];   // getting the z positon index.
            z = m[z];   // getting layers at z position.
            sl = sl.concat(z);  // could use sl.push.apply(sl, z);
        }

        return sl;
    }

    // Creating Resources.


    /**
     * Creates a pattern reference from a region of an image.
     *
     * @return {CanvasPattern}
     */
    exports.createPatternBuffer = function(ctx,image,x,y,width,height,repeat){

        _patternBuffer.canvas.width = width;
        _patternBuffer.canvas.height = height;


        _patternBuffer.clearRect(0,0,width,height);

        _patternBuffer.drawImage(image,x,y,width,height,0,0,width,height);

        var pattern = nativeContext.createPattern(buffer.canvas,repeat);

        return pattern;
    }

    /**
     * Creates a pattern from a image or canvas.
     *
     * @return {CanvasPattern}
     */
    exports.createPattern = function(image,repeat){
        return nativeContext.createPattern(image,repeat);
    }


    /**
     * Creates a empty ImageData object.
     *
     * @return {ImageData}
     */
    exports.createImageData = function(height,repeat){
        return nativeContext.createImageData(height,repeat);
    }


    /**
     * Creates a linear gradient notation object.
     *
     * @return {CanvasGradient}
     */
    exports.createLinearGradient = function(x1, y1, x2, y2){
        return nativeContext.createLinearGradient(x1, y1, x2, y2);
    }


    /**
     * Creates a radial gradient notation object.
     *
     * @return {CanvasGradient}
     */
    exports.createRadialGradient = function(x1, y1, r1, x2, y2, r2){
        return nativeContext.createRadialGradient(x1, y1, r1, x2, y2, r2);
    }


    return exports;
}());

// this shouln't be here.
var _patternBuffer = document.createElement('canvas').getContext('2d');
