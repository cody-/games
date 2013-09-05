//
//  SGGNode.h
//  Pew-pewNinja
//
//  Created by cody on 9/4/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>

@interface SGGNode : NSObject

@property (assign) GLKVector2 position;
@property (assign) CGSize contentSize;
@property (assign) GLKVector2 moveVelocity;
@property (retain) NSMutableArray* children;

- (void)renderWithModelViewMatrix:(GLKMatrix4)modelViewMatrix;
- (void)update:(float)dt;
- (GLKMatrix4)modelMatrix:(BOOL)renderingSelf;
- (CGRect)boundingBox;
- (void)addChild:(SGGNode*)child;
- (void)handleTap:(CGPoint)touchLocation;

@end
