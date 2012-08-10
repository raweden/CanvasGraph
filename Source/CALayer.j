//
// CALayer.j
// Core Canvas
//
// Created by Raweden. Wed Jul 25 2012
// Copyright 2012 Raweden. All rights reserved.
//

@import <Foundation/CPObject.j>

@import "CGGeom.j"
@import "CGColor.j"
@import "CGRender.j"
//@import "CGImage.j"
@import "CGAffineTransform.j"
//@import "CAPath.j"
//@import "CAShadow.j"


//
// TODO: add support for the content attribute.
// TODO: add support for realtime filters.
// TODO: layer masking: for making use of mask a bitmap masking algerythm to be implemented.
// TODO: another flags should be set when the frame is set and only the origin is changed.
//       this flag should not trigger the layer to call drawRect: on the delegate.
//

@implementation CALayer : CPObject{

    // Managing Layer
    CALayer _superlayer;     //@accessors(readonly, getter=superlayer);
    CPArray _sublayers;      //@accessors(readonly, getter=sublayers);
    id _delegate;
    // Modifying Layer Geometery
    CGRect _frame;           //@accessors(property=frame);
    CGRect _bounds;          //@accessors(property=bounds);
    CGPoint _anchorPoint;    //@accessors(property=anchorPoint);         // Default CGPointMake(0.5 & 0.5); // center of layer.
    CGAffineTransform _transform;
    int _zPosition;          //@accessors(property=zPosition);

    // Layer Style
    Number _opacity;         //@accessors(property=zPosition);
    Boolean _hidden;         //@accessors(setter=setHidden,getter=isHidden);
    Number _cornerRadius;    //@accessors(property=cornerRadius);
    Number _borderWidth;     //@accessors(property=borderWidth);
    CGColor _borderColor;    //@accessors(property=borderColor);
    CGColor _backgroundColor;
    Boolean _masksToBounds;  //@accessors(property=masksToBounds);
    CALayer _mask;           //@accessors(property=mask);

    // Providing Layer Content
    CGImage _contents;           // An Object that provides the content of the layer, can be set to ImageData or a DOM Image object.
    String _contentsCenter;      // Specifies the area of the content image that should be scaled. Animatable.
                                // contents gravity enums: 'center', 'top', 'bottom', 'left', 'right', 'left', 'topright', 'bottomleft', 'bottomright', 'resize', 'aspect', 'fill'
    String _contentsGravity;
    CGRect _contentsRect;        // A instance of Rectangle
    Number _contentsScale;       // floating point number, where 1.0 is default scale.

    // Shadow.
    CAShadow _shadow;
//  CGPath shadowPath;        // instance of CGPath

    // Rendering
    Boolean _shouldRasterize;
    Number _rasterizationScale;
}


#pragma mark Creating Layers


-(id)init
{
    self = [super init];
    if(self){
        _superlayer = null;
        _sublayers = new Array();
        _frame = CGRectMakeZero();
        _bounds = CGRectMakeZero();
        _anchorPoint = CGPointMake(0.5,0.5);
        _zPosition = 0;
        _opacity = 1;
        _hidden = false;
        _cornerRadius = 0;
        _borderWidth = 0;
        _backgroundColor;
        _contents = null;
        _contentsCenter = null;
        _contentsGravity = 'center';
        _contentsRect = null;
        _contentsScale = 1.0;
        _shadow = null;
        _shadowPath = null;
        _shouldRasterize = false;
        _rasterizationScale = 1.0;
        _masksToBounds = false;
    }
    return self;
}


#pragma mark Managing the Layer Hierarchy


/**
 * Indicates the child layers of this layer (Read-only).
 */
-(Array)sublayers
{
    return _sublayers.concat();
}

/**
 * Indicates the super layers of this layer (Read-only).
 */
-(CALayer)superlayer
{
    return _superlayer;
}

-(void)addSublayer:(CALayer)layer
{
    if(self === layer){
        throw new Error("Cannot add layer to itself");
    }else if(!layer){
        throw new Error("layer may not be null");
    }
    // @Todo assertion, ensure that layer is instance of Layer.

    [layer removeFromSuperlayer];
    _sublayers.push(layer);
    layer._superlayer = self;
    [self setNeedsDisplay];
}

-(void)insertLayer:(CALayer)layer atIndex:(int)index
{
    // @Todo assertion, ensure that layer is instance of Layer.
    [layer removeFromSuperlayer];
    // @Todo assert range.

    _sublayers.splice(index, 0, layer);
    [self setNeedsDisplay];
}

-(void)insertLayer:(CALayer)layer aboveLayer:(CALayer)sibling
{
    // @Todo assertion, ensure that sibling is instance of Layer.

    var index = _sublayers.indexOf(sibling);

    if(index == -1){
        return;
    }

    _sublayers.splice(index + 1, 0, layer);
    [self setNeedsDisplay];
}

-(void)insertLayer:(CALayer)layer belowLayer:(CALayer)sibling
{
    // @Todo assertion, ensure that sibling is instance of Layer.

    var index = _sublayers.indexOf(sibling);

    if(index == -1){
        return;
    }

    _sublayers.splice(index + 1, 0, layer);
    [self setNeedsDisplay];
}

-(void)removeFromSuperlayer
{
    var superlayer = _superlayer;
    if(!_superlayer){
        return;
    }

    var layers = superlayer._sublayers;
    var index = layers ? layers.indexOf(this) : -1;

    if(index == -1){
        return;
    }

    layers.splice(index, 1);
    [superlayer setNeedsDisplay];
}

-(void)replaceLayer:(CALayer)layer1 withLayer:(CALayer)layer2
{
    // @Todo assertion, ensure that layer2 is instance of Layer.
    var index = _sublayers.indexOf(layer1);

    if(index == -1){
        return;
    }

    _sublayers[index] = layer2;
    [self setNeedsDisplay];
}


#pragma mark Converting Between Cordinate Space


-(CGPoint)convertPoint:(CGPoint)point fromLayer:(CALayer)layer
{
    return CGPointApplyAffineTransform(point, CALayerGetTransform(layer, self));
}

-(CGPoint)convertPoint:(CGPoint)point toLayer:(CALayer)aLayer
{
    return CGPointApplyAffineTransform(point, CALayerGetTransform(self, layer));
}

-(CGRect)convertRect:(CGRect)rect fromLayer:(CALayer)aLayer
{
    return CGPointApplyAffineTransform(rect, CALayerGetTransform(layer, self));
}

-(CGRect)convertRect:(CGRect)rect toLayer:(CALayer)layer
{
    return CGPointApplyAffineTransform(rect, CALayerGetTransform(self, layer));
}


#pragma mark Hit Testing


-(Boolean)hitTestPoint:(Point) point
{

}


-(Boolean)containsPoint:(Point) point
{
    return CGRectContainsPoint(_bounds, point);
}


#pragma mark Rendering


-(void)setShouldRasterize:(Boolean) value
{
    if(value == _shouldRasterize){
        return;
    }

    // @Todo the content this layer and it's children should be renderd into a buffer-canvas or the canvas should be retained.
    _shouldRasterize = value;
}

-(Boolean)shouldRasterize
{
    return _shouldRasterize;
}

-(void)setRasterizationScale:(Number) value
{
    if(value == _rasterizationScale){
        return;
    }

    // @Todo the content this layer and it's children should be renderd into a buffer-canvas or the canvas should be retained.
    _rasterizationScale = value;
}

-(Number)rasterizationScale
{
    return _rasterizationScale;
}


-(void)drawInContext:(Context2D)ctx
{

}


-(void)setNeedsDisplay
{
    Quartz.flagLayerAsDirty(self);
}


-(void)setDelegate:(id) value
{
    _delegate = value;
}

-(id)delegate
{
    return _delegate;
}


#pragma mark Layer Style.


-(void)setOpacity:(Number) value
{
    value = Math.max(0,value);
    value = Math.min(1,value);
    _opacity = value;
    [self setNeedsDisplay];
}

-(Number)opacity
{
    return _opacity;
}


-(void)setHidden:(Boolean) value
{
    if(value == _hidden){
        return;
    }
    _hidden = value;
    [self setNeedsDisplay];
}

-(Boolean)hidden
{
    return _hidden;
}


-(void)setCornerRadius:(Number) value
{
    _cornerRadius = value;
    [self setNeedsDisplay];
}

-(Number)cornerRadius
{
    return _cornerRadius;
}


-(void)setBorderWidth:(Number) value
{
    _borderWidth = value;
    [self setNeedsDisplay];
}

-(Number)borderWidth
{
    return _borderWidth;
}


-(void)setBorderColor:(CGColor) value
{
    _borderColor = value;
    [self setNeedsDisplay];
}

-(CGColor)borderColor
{
    return _borderColor;
}


-(void)setBackgroundColor:(CGColor) value
{
    if(false /*[value.isEqual:_backgroundColor]*/){
        return;
    }

    _backgroundColor = value;
    [self setNeedsDisplay];
}

-(CGColor)backgroundColor
{
    return _backgroundColor;
}


-(void)setMasksToBounds:(Boolean) value
{
    if(value === _masksToBounds){
        return;
    }

    _masksToBounds = value;
    [self setNeedsDisplay];
}

-(Boolean)masksToBounds
{
    return _masksToBounds;
}


-(void)mask:(CALayer) value
{
    _mask = value;
    [self setNeedsDisplay];
}

-(CALayer)mask
{
    return _mask;
}


#pragma mark Modifying the Layer Geometry


-(void)setFrame:(CGRect) value
{
    _frame = value;
    [self setNeedsDisplay];
}

-(CGRect)frame
{
    return CGRectMakeCopy(_frame);
}


-(void)setBounds:(CGRect) value
{
    if(CGRectEqualToRect(value, _bounds)){
        return;
    }

    _bounds = value;
    [self setNeedsDisplay];
}

-(CGRect)bounds
{
    return CGRectMakeCopy(_bounds);
}


-(void)setZPosition:(int) value
{
    if(value == _zPosition){
        return;
    }

    _zPosition = value;
    [self setNeedsDisplay];
}

-(int)zPosition
{
    return _zPosition;
}


-(void)setTransform:(CGTransform) value
{
    if(value == _transform){
        return;
    }

    _transform = value;
    [self setNeedsDisplay];
}

-(CGTransform)transform
{
    return _transform;
}


-(void)setAnchorPoint:(CGPoint) value
{
    if(!value){
        value = CGPointMake(0.5,0.5);
    }
    if([_anchorPoint equalTo:value]){
        return;
    }

    _anchorPoint = value;
    [self setNeedsDisplay];
}

-(CGPoint)anchorPoint
{
    return _anchorPoint;
}


#pragma mark Scrolling.


-(CGRect)visibleRect
{
    // @Todo Implement this method.
    // Get visible region which are not clipped by the containing scroll layer.
    return null;
}

-(void)scrollPoint:(CGPoint)point
{
    if([self kindOfClass:CAScrollLayer]){
        [self scrollToPoint:point];
        return;
    }

    var l = self;
    while(l = [l superlayer]){
        if([l isKindOfClass:CAScrollLayer]){
            [l scrollToPoint:point];
            return;
        }
    }
}

-(void)scrollRectToVisible:(CGRect)rect
{
    if([self kindOfClass:CAScrollLayer]){
        [self scrollToRect:rect];
        return;
    }

    var l = self;
    while(l = [l superlayer]){
        if([l kindOfClass:CAScrollLayer]){
            [l scrollToRect:rect];
            return;
        }
    }
}


#pragma mark Providing Layer Content


-(void)setContents:(CGImage)value
{
    _contents = value;
    [self setNeedsDisplay];
}

-(CGImage)contents
{
    return _contents;
}


-(void)setContentsRect:(CGRect)value
{
    _contentsRect = value;
    [self setNeedsDisplay];
}

-(CGRect)contentsRect
{
    return _contentsRect
}


-(void)setContentsCenter:(CGPoint)value
{
    _contentsCenter = value;
    [self setNeedsDisplay];
}

-(CGPoint)contentsCenter
{
    return _contentsCenter
}


-(void)setContentsScale:(Number)value
{
    _contentsScale = value;
    [self setNeedsDisplay];
}

-(Number)contentsScale
{
    return _contentsScale
}

@end

/**
 * Returns the transformation applied to a layer in relation to another.
 *
 * https://github.com/cappuccino/cappuccino/blob/master/AppKit/CoreAnimation/CALayer.j
 * TODO: move this to CGRender.j
 */
function CALayerGetTransform(fromLayer, toLayer){
    var transform = CGAffineTransformMakeIdentity();
    if (fromLayer){
        var layer = fromLayer;
        // If we have a fromLayer, "climb up" the layer tree until
        // we hit the root node or we hit the toLayer.
        while (layer && layer != toLayer){
            //var transformFromLayer = layer._transformFromLayer;
            var frame = [layer frame];
            var origin = frame.origin;
            var transformFromLayer = CGAffineTransformMake(1.0, 0.0, 0.0, 1.0, origin.x,origin.y);
            //transform = CGAffineTransformConcat(transform, layer._transformFromLayer);
            CGAffineTransformConcatTo(transform, transformFromLayer, transform);
            layer = layer._superlayer;
        }
        // If we hit toLayer, then we're done.
        if (layer == toLayer){
            return transform;
        }
    }

    var layers = [];
    var layer = toLayer;

    while (layer){
        layers.push(layer);
        layer = layer._superlayer;
    }

    var index = layers.length;
    while (index--){
        //var transformToLayer = layers[index]._transformToLayer;
        var frame = layers[index]._frame;
        var origin = frame.origin;
        var transformToLayer = CGAffineTransformMake(1.0, 0.0, 0.0, 1.0, origin.x,origin.y);
        transformToLayer = CGAffineTransformInvert(transformToLayer);

        CGAffineTransformConcatTo(transform, transformToLayer, transform);
    }

    return transform;
}

