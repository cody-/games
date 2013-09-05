//
//  NinjaGLKViewController.m
//  Pew-pewNinja
//
//  Created by cody on 9/3/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#import "SGGViewController.h"
#import "SGGActionScene.h"

@interface SGGViewController()

@property (strong, nonatomic) EAGLContext* context;
@property (strong) GLKBaseEffect* effect;

@end

@implementation SGGViewController

///
- (void)viewDidLoad
{
    [super viewDidLoad];
	self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	if (!self.context)
	{
		NSLog(@"Failed to create ES context");
	}
	GLKView* view = (GLKView*)self.view;
	view.context = self.context;
	[EAGLContext setCurrentContext:self.context];

	self.effect = [[GLKBaseEffect alloc] init];

	GLKMatrix4 projectionMatrix = GLKMatrix4MakeOrtho(0, 1024, 0, 768, -1024, 1024);
	self.effect.transform.projectionMatrix = projectionMatrix;

	// Tap recognizer
	UITapGestureRecognizer* tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
	[self.view addGestureRecognizer:tapRecognizer];

	self.scene = [[SGGActionScene alloc] initWithEffect:self.effect];
}

///
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

///
- (void)handleTapFrom:(UITapGestureRecognizer*)recognizer
{
	// Flip touch point (iPad coord system -> OpenGL coord system)
	CGPoint touchLocation = [recognizer locationInView:recognizer.view];
	touchLocation = CGPointMake(touchLocation.x, 768 - touchLocation.y);

	[self.scene handleTap:touchLocation];
}

#pragma mark - GLKViewDelegate

///
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
	glClearColor(1, 1, 1, 1);
	glClear(GL_COLOR_BUFFER_BIT);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);

	[self.scene renderWithModelViewMatrix:GLKMatrix4Identity];
}

///
- (void)update
{
	[self.scene update:self.timeSinceLastUpdate];
}


@end
