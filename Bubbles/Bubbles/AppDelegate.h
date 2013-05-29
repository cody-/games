//
//  AppDelegate.h
//  Bubbles
//
//  Created by cody on 5/17/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SceneViewDelegate.h"

@interface AppDelegate : NSObject <NSApplicationDelegate, SceneViewDelegate>

@property (assign) IBOutlet NSWindow *window;

@end
