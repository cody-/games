//
//  AppDelegate.m
//  Bubbles
//
//  Created by cody on 5/17/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#import "AppDelegate.h"
#import "SceneView.h"
#import "GameWidget.hpp"

@interface AppDelegate()
{
	GameWidget* game_;
}

@property (weak) IBOutlet SceneView *glView;

-(void)setupTimers;
-(void)updateGame:(NSTimer*)timer;
-(void)updateScene:(NSTimer*)timer;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
}

///
- (void)dealloc
{
	delete game_;
}

///
- (void)awakeFromNib
{
	[self.glView setDelegate:self];
}

///
- (void)preliminaries
{
	NSRect bounds = [self.glView bounds];
	game_ = new GameWidget(bounds.size.width, bounds.size.height);
	[self setupTimers];
}

///
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender
{
	return YES;
}

///
- (void)setupTimers
{
	NSTimer* updateTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(updateGame:) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:updateTimer forMode:NSDefaultRunLoopMode];

	NSTimer* renderTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(updateScene:) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:renderTimer forMode:NSDefaultRunLoopMode];
}

///
- (void)updateScene:(NSTimer*)timer
{
	[self.glView setNeedsDisplay:YES];
}

///
- (void)updateGame:(NSTimer*)timer
{
	game_->Update([timer timeInterval]);
}

///
- (void)draw
{
	game_->Draw();
}

///
- (void)resizeScene:(NSRect)bounds
{
	const float width  = bounds.size.width;
	const float height = bounds.size.height;
	
	game_->ResizeScene(width, height);
}

///
- (void)mouseUp:(NSPoint)point
{
	game_->Click({(float)point.x, (float)point.y});
}

@end
