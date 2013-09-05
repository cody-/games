//
//  SGGActionScene.m
//  Pew-pewNinja
//
//  Created by cody on 9/4/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#import "SGGActionScene.h"
#import "SGGSprite.h"
#import "SGGGameOverScene.h"
#import "AppDelegate.h"
#import "SGGViewController.h"

@interface SGGActionScene()

@property (strong) GLKBaseEffect* effect;
@property (strong) SGGSprite* player;
@property (assign) float timeSinceLastSpawn;
@property (strong) NSMutableArray* projectiles;
@property (strong) NSMutableArray* targets;
@property (assign) int targetsDestroyed;

@end

@implementation SGGActionScene

///
- (id)initWithEffect:(GLKBaseEffect *)effect
{
	self = [super init];
	if (self)
	{
		self.effect = effect;

		// Make player
		self.player = [[SGGSprite alloc] initWithFile:@"Player.png" effect:self.effect];
		self.player.position = GLKVector2Make(self.player.contentSize.width/2, 384);
		[self.children addObject:self.player];

		self.projectiles = [NSMutableArray array];
		self.targets = [NSMutableArray array];
	}
	return self;
}

///
- (void)handleTap:(CGPoint)touchLocation
{
	// Normalized vector (ninja -> touch point)
	GLKVector2 target = GLKVector2Make(touchLocation.x, touchLocation.y);
	GLKVector2 offset = GLKVector2Subtract(target, self.player.position);
	GLKVector2 normalizedOffset = GLKVector2Normalize(offset);

	// Velocity for shuricen movement (width per second)
	static float POINTS_PER_SECOND = 1024;
	GLKVector2 moveVelocity = GLKVector2MultiplyScalar(normalizedOffset, POINTS_PER_SECOND);

	// Launch shuricen
	SGGSprite* sprite = [[SGGSprite alloc] initWithFile:@"Projectile.png" effect:self.effect];
	sprite.position = self.player.position;
	sprite.moveVelocity = moveVelocity;
	[self.children addObject:sprite];
	[self.projectiles addObject:sprite];
}

///
- (void)addTarget
{
	SGGSprite* target = [[SGGSprite alloc] initWithFile:@"Target.png" effect:self.effect];
	[self.children addObject:target];

	int minY = target.contentSize.height/2;
	int maxY = 768 - target.contentSize.height/2;
	int rangeY = maxY - minY;
	int actualY = (arc4random() % rangeY) + minY;

	target.position = GLKVector2Make(1024 + (target.contentSize.width/2), actualY);

	int minVelocity = 1024.0/4.0;
	int maxVelocity = 1024.0/2.0;
	int rangeVelocity = maxVelocity - minVelocity;
	int actualVelocity = (arc4random() % rangeVelocity) + minVelocity;

	target.moveVelocity = GLKVector2Make(-actualVelocity, 0);
	[self.targets addObject:target];
}

///
- (void)gameOver:(BOOL)win
{
	SGGGameOverScene* gameOver = [[SGGGameOverScene alloc] initWithEffect:self.effect win:win];

	AppDelegate* delegate = [[UIApplication sharedApplication] delegate];
	UIWindow* mainWindow = [delegate window];
	SGGViewController* viewController = (SGGViewController*)mainWindow.rootViewController;
	viewController.scene = gameOver;
}

///
- (void)update:(float)dt
{
	[super update:dt];

	// Collision detection and removing destroyed objects
	NSMutableArray* projectilesToDelete = [NSMutableArray array];
	for (SGGSprite* projectile in self.projectiles)
	{
		NSMutableArray* targetsToDelete = [NSMutableArray array];
		for (SGGSprite* target in self.targets)
		{
			if (CGRectIntersectsRect(projectile.boundingBox, target.boundingBox))
			{
				[targetsToDelete addObject:target];
			}
		}

		for (SGGSprite* target in targetsToDelete)
		{
			[self.targets removeObject:target];
			[self.children removeObject:target];
			++_targetsDestroyed;
		}

		if (targetsToDelete.count > 0)
		{
			[projectilesToDelete addObject:projectile];
		}
	}

	for (SGGSprite* projectile in projectilesToDelete)
	{
		[self.projectiles removeObject:projectile];
		[self.children removeObject:projectile];
	}

	// Spawn new targets
	self.timeSinceLastSpawn += dt;
	if (self.timeSinceLastSpawn > 1.0)
	{
		self.timeSinceLastSpawn = 0;
		[self addTarget];
	}

	if (_targetsDestroyed > 5)
	{
		[self gameOver:YES];
		return;
	}

	BOOL lose = NO;
	for (int i = self.children.count - 1; i >= 0; --i)
	{
		SGGSprite* sprite = [self.children objectAtIndex:i];

		if (   sprite.position.x <= -sprite.contentSize.width/2
			|| sprite.position.x > 1024 + sprite.contentSize.width/2
			|| sprite.position.y <= -sprite.contentSize.height/2
			|| sprite.position.y >= 768 + sprite.contentSize.height/2
		)
		{
			if ([self.targets containsObject:sprite])
			{
				[self.targets removeObject:sprite];
				[self.children removeObjectAtIndex:i];
				lose = YES;
			}
			else if ([self.projectiles containsObject:sprite])
			{
				[self.projectiles removeObject:sprite];
				[self.children removeObjectAtIndex:i];
			}
		}
	}

	if (lose)
	{
		[self gameOver:NO];
	}
}

@end
