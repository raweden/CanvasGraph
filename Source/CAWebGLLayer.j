//
// CAGLLayer.j
// Core Canvas
//
// Created by Raweden. Sat Jul 2012
// Copyright 2012 Raweden. All rights reserved.
//


@import "CALayer.j"


/**
 * A CAWebGLLayer object enables Web GL content to be renderd within the layer hierarchy.
 *
 * You should subclass this class to provide the content, override drawInGLContext:atDisplayTime: to draw each frame.
 */
@implementation CAWebGLLayer : CALayer
{

}

-(id)init
{
	self = [super init];
	if(self){
		// set rasterization flag.
	}

	return self;
}

/**
 * This method are used by the rendering core to determine whether the layers needs to be redrawn.
 *
 * The default implementation returns `false`.
 *
 * @param glContext
 * @param time A unix timestamp.
 * @return A Boolean value that indicates to the rendering core whether this layer needs to redraw.
 */
-(Boolean)shouldDrawInGLContext:(WebGLRenderingContext)glContext atDisplayTime:(int)time
{
	return false;
}

/**
 * Draws the Web GL content for the specified time.
 *
 * This method are used by the rendering core to determine whether the layers needs to be redrawn.
 *
 * The default implementation flushes the context.
 * @param glContext The rendering context in to which the OpenGL content should be rendered.
 * @param time The display timestamp associated with timeInterval.
 */
-(void)drawInGLContext:(WebGLRenderingContext)glContext atDisplayTime:(int)time
{
	glContext.flush();
}

@end
