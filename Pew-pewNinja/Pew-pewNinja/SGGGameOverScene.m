//
//  SGGGameOverScene.m
//  Pew-pewNinja
//
//  Created by cody on 9/4/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#import "SGGGameOverScene.h"
#import "SGGSprite.h"
#import "SGGViewController.h"
#import "SGGActionScene.h"
#import "AppDelegate.h"

@interface SGGGameOverScene()
@property (assign) float timeSinceInit;
@property (strong) GLKBaseEffect* effect;
@end

@implementation SGGGameOverScene

///
- (id)initWithEffect:(GLKBaseEffect *)effect win:(BOOL)win
{
	self = [super init];
	if (self)
	{
		self.effect = effect;
		SGGSprite* imgSprite = [[SGGSprite alloc] initWithFile:(win ? @"YouWin.png" : @"YouLose.png") effect:effect];
		imgSprite.position = GLKVector2Make(512, 384);
		[self addChild:imgSprite];
	}
	return self;
}

///
- (void)update:(float)dt
{
	self.timeSinceInit += dt;
	if (self.timeSinceInit > 3.0)
	{
		SGGActionScene* scene = [[SGGActionScene alloc] initWithEffect:self.effect];
		AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
		UIWindow* mainWindow = [delegate window];
		SGGViewController* viewController = (SGGViewController*)mainWindow.rootViewController;
		viewController.scene = scene;
	}
}

@end
