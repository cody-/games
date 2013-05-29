//
//  SceneView.m
//  Bubbles
//
//  Created by cody on 5/17/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#import "SceneView.h"
#import "SceneViewDelegate.h"
#import <OpenGl/gl.h>

@implementation SceneView

///
- (void)drawRect:(NSRect)dirtyRect
{
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	[self.delegate draw];
	glFlush();
}

///
- (void)reshape
{
	[super reshape];
	[self.delegate resizeScene:[self bounds]];
}

///
- (void)mouseUp:(NSEvent *)theEvent
{
	[self.delegate mouseUp:[theEvent locationInWindow]];
}

///
- (void)prepareOpenGL
{
	[super prepareOpenGL];
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	[self.delegate preliminaries];
}

@end
