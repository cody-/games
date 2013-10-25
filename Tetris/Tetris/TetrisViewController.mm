//
//  TetrisViewController.m
//  Tetris
//
//  Created by cody on 9/5/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#import "TetrisViewController.h"
#import "ShaderProgram.h"
#import "Scene.h"
#include "./TextureLoader.h"
#include "./Game.h"

bool g_resetTouchTimer = false;

@interface TetrisViewController() <UIGestureRecognizerDelegate>
{
	ShaderProgram* program_;
	Scene* scene_;
	Game* game_;
}

@property (strong, nonatomic) EAGLContext* context;
@property (strong) NSTimer* touchTimer;

- (void)setupGL;
- (void)tearDownGL;
- (void)touchByTimer:(NSTimer*)timer;
- (void)resetTouchTimer;
- (void)setNewTimerForTouch:(UITouch*)touch;

@end

@implementation TetrisViewController

///
- (void)viewDidLoad
{
	self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	if (!self.context)
	{
		NSLog(@"Failed to create ES context");
	}
	GLKView* view = (GLKView*)self.view;
	view.context = self.context;
	[EAGLContext setCurrentContext:self.context];

	program_ = new ShaderProgram();

	//NSLog(@"%f x %f", self.view.bounds.size.width, self.view.bounds.size.height);
	CGSize windowSize = CGSizeMake(self.view.bounds.size.height, self.view.bounds.size.width); // Album orientation
	program_->projectionMatrix = GLKMatrix4MakeOrtho(0, windowSize.width, 0, windowSize.height, -1024, 1024);
	scene_ = new Scene(windowSize);

	game_ = new Game(scene_->GameFieldRef(), scene_->InfoPanelRef());
	game_->SetTouchdownCallback([&]{ g_resetTouchTimer = true; });

	scene_->SetTrigger(Btn::ROTATE, [=]{ game_->Rotate(); });
	scene_->SetTrigger(Btn::LEFT, [=]{ game_->MoveLeft(); });
	scene_->SetTrigger(Btn::RIGHT, [=]{ game_->MoveRight(); });
	scene_->SetTrigger(Btn::DOWN, [=]{ game_->MoveDown(); });
	scene_->SetTrigger(Btn::SETTINGS, [=]{ game_->Pause(); });

	[self.view setMultipleTouchEnabled:YES];

	[self setupGL];
}

///
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

///
- (void)handleTouch:(UITouch*)touch
{
	// Flip touch point (iPad coord system -> OpenGL coord system)
	CGPoint location = [touch locationInView:self.view];
	scene_->HandleTap(CGPointMake(location.x, self.view.bounds.size.height - location.y));
}

///
- (void)touchByTimer:(NSTimer*)timer
{
	UITouch* touch = [timer userInfo];
	[self handleTouch:touch];
}

///
- (void)resetTouchTimer
{
	g_resetTouchTimer = false;
	if (!self.touchTimer)
		return;

	UITouch* touch = self.touchTimer.userInfo;
	[self.touchTimer invalidate];
	[self setNewTimerForTouch:touch];
}

///
- (void)setNewTimerForTouch:(UITouch*)touch
{
	self.touchTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(touchByTimer:) userInfo:touch repeats:YES];
	[self.touchTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:0.2]];
	[[NSRunLoop currentRunLoop] addTimer:self.touchTimer forMode:NSDefaultRunLoopMode];
}

///
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	for (UITouch* touch in touches)
	{
		[self handleTouch:touch];
		if (!self.touchTimer)
		{
			[self setNewTimerForTouch:touch];
		}
	}
}

///
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	for (UITouch* touch in touches)
	{
		if (self.touchTimer && self.touchTimer.userInfo == touch)
		{
			[self.touchTimer invalidate];
			self.touchTimer = nil;
		}
	}
}

///
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
}

///
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self touchesEnded:touches withEvent:event];
}

///
- (void)dealloc
{
    [self tearDownGL];

	delete game_;
	delete scene_;
	TextureLoader::RemoveInstance();
    
    if ([EAGLContext currentContext] == self.context) {
        [EAGLContext setCurrentContext:nil];
    }
}

///
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

    if ([self isViewLoaded] && ([[self view] window] == nil)) {
        self.view = nil;
        
        [self tearDownGL];
        
        if ([EAGLContext currentContext] == self.context) {
            [EAGLContext setCurrentContext:nil];
        }
        self.context = nil;
    }

    // Dispose of any resources that can be recreated.
}

///
- (void)setupGL
{
    [EAGLContext setCurrentContext:self.context];
    program_->LoadShaders();
}

- (void)tearDownGL
{
    [EAGLContext setCurrentContext:self.context];
	delete program_;
}

#pragma mark GLKView and GLKViewController delegates

///
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
	glClearColor(0, 1, 1, 1);
	glClear(GL_COLOR_BUFFER_BIT);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);

	program_->Use();
	scene_->Render(*program_, GLKMatrix4Identity);
}

///
- (void)update
{
	game_->Update(self.timeSinceLastUpdate);
	scene_->Update(self.timeSinceLastUpdate);
	if (g_resetTouchTimer)
		[self resetTouchTimer];
}

@end
