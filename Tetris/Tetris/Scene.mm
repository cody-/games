//
//  Scene.mm
//  Tetris
//
//  Created by cody on 9/9/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./Scene.h"
#include "./GameField.h"
#include "./Button.h"

using namespace std;

///
Scene::Scene(const CGSize& size)
{
	contentSize_ = size;

	CGFloat offset = (size.width - GameField::Width())/2;
	GameField* field = new GameField(CGPointMake(offset, 0), size.height);
	children_.push_back(unique_ptr<Node>(field));

	CGFloat btnY = size.height*2/3;
	CGFloat btnOffsetX = 30;
	CGFloat btnRadius = 40;
	
	children_.push_back(unique_ptr<Node>(new Button("rotate.png", btnRadius, {size.width - (btnOffsetX + 2*btnRadius), btnY}, [&]{ Rotate(); })));
	children_.push_back(unique_ptr<Node>(new Button("arrow left.png", btnRadius, {btnOffsetX, btnY}, [&]{ MoveLeft(); })));
	children_.push_back(unique_ptr<Node>(new Button("arrow right.png", btnRadius, {2*btnOffsetX + 2*btnRadius, btnY}, [&]{ MoveRight(); })));
	children_.push_back(unique_ptr<Node>(new Button("arrow down.png", btnRadius, {btnOffsetX*1.5f + btnRadius, btnY - 2*btnRadius}, [&]{ MoveDown(); })));
}

///
bool Scene::HandleTap(const CGPoint& point)
{
	for (const auto& child : children_)
	{
		if (child->HandleTap(point))
			break;
	}

	return true;
}

///
void Scene::MoveLeft()
{
	NSLog(@"Move left");
}

///
void Scene::MoveRight()
{
	NSLog(@"Move right");
}

///
void Scene::MoveDown()
{
	NSLog(@"Move down");
}

///
void Scene::Rotate()
{
	NSLog(@"Rotate");
}
