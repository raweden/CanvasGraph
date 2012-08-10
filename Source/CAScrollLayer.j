//
// CAScrollLayer.j
// Core Canvas
//
// Created by Raweden. Wed Jun 13 2012
// Copyright 2012 Raweden. All rights reserved.
//

@import "CGGeom.j"
@import "CALayer.j"

/*
enum{
    CAScrollModeNone,
    CAScrollModeBoth,
    CAScrollModeVertically,
    CAScrollModeHorizontally
} CAScrollMode
*/

/**
 * A CASCrollLayer simplifies displaying a portion of a layer, the scrollable content
 * is defined by the layout of it's sublayers. The visible portion of the layer
 * is set by specifying the orgin as a point or rectangular area, A CAScrollLayer
 * doesn't provide keyboard or mouse event handling, nor does it provide any visible
 * scrollers.
 */
@implementation CAScrollLayer : CALayer
{
    CAScrollMode _scrollMode;
    Number _scrollX;
    Number _scrollY;
}

-(void)init
{
    self = [super init];
    if(self){
        _scrollMode = 3;
        _scrollX = 0;
        _scrollY = 0;
    }

    return self;
}

-(void)setScrollMode:(CAScrollMode)mode
{
    _scrollMode = mode;
}

-(CAScrollMode)scrollMode
{
    return _scrollMode;
}

/**
 * Changes the origin of the layer's visiable rectangle to the specified point.
 * @param point The new origin.
 */
-(void)scrollToPoint:(CGPoint)point
{
    //var scrollX = point.x;;
    //var scrollY = point.y;

    if(_scrollMode === 0){
        return;
    }else if(_scrollMode == 1){
        _scrollY = point.y;
        [self setNeedsDisplay];
    }else if(_scrollMode == 2){
        _scrollX = point.x;
        [self setNeedsDisplay];
    }else if(_scrollMode == 3){
        _scrollX = point.x;
        _scrollY = point.y;
        [self setNeedsDisplay];
    }
}

/**
 * Scrolls the content of the layer to ensure that the rectangle is visible.
 *
 * @param rect The rectangle that should be visible.
 */
-(void)scrollToRect:(CGRect)rect
{
    //scrollX = point.x;
    //scrollY = point.y;
}

@end
