//
//  SceneView.h
//  Bubbles
//
//  Created by cody on 5/17/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol SceneViewDelegate;

@interface SceneView : NSOpenGLView
@property (weak) id<SceneViewDelegate> delegate;
@end
