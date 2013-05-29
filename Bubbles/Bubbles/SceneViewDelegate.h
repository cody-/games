//
//  SceneViewDelegate.h
//  Bubbles
//
//  Created by cody on 5/17/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SceneViewDelegate <NSObject>
- (void)preliminaries;
- (void)draw;
- (void)resizeScene:(NSRect)bounds;
- (void)mouseUp:(NSPoint)point;
@end
