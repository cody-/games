//
//  SGGNode.m
//  Pew-pewNinja
//
//  Created by cody on 9/4/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#import "SGGNode.h"

@implementation SGGNode

///
- (id)init
{
	self = [super init];
	if (self)
	{
		self.children = [NSMutableArray array];
	}
	return self;
}

///
- (void)renderWithModelViewMatrix:(GLKMatrix4)modelViewMatrix
{
	GLKMatrix4 childModelViewMatrix = GLKMatrix4Multiply(modelViewMatrix, [self modelMatrix:NO]);
	for (SGGNode* node in self.children)
	{
		[node renderWithModelViewMatrix:childModelViewMatrix];
	}
}

///
- (void)update:(float)dt
{
	for (SGGNode* node in self.children)
	{
		[node update:dt];
	}

	GLKVector2 curMove = GLKVector2MultiplyScalar(self.moveVelocity, dt);
	self.position = GLKVector2Add(self.position, curMove);
}

///
- (GLKMatrix4)modelMatrix:(BOOL)renderingSelf
{
	GLKMatrix4 modelMatrix = GLKMatrix4Identity;
	modelMatrix = GLKMatrix4Translate(modelMatrix, self.position.x, self.position.y, 0);
	if (renderingSelf)
	{
		modelMatrix = GLKMatrix4Translate(modelMatrix, -self.contentSize.width/2, -self.contentSize.height/2, 0);
	}
	return modelMatrix;
}

///
- (CGRect)boundingBox
{
	CGRect rect = CGRectMake(self.position.x, self.position.y, self.contentSize.width, self.contentSize.height);
	return rect;
}

///
- (void)addChild:(SGGNode *)child
{
	[self.children addObject:child];
}

///
- (void)handleTap:(CGPoint)touchLocation
{
}

@end
