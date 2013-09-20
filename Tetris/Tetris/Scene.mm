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
#include "./Square.h"

using namespace std;

///
Scene::Scene(const CGSize& size)
	: TexturedNode("bg-tech.jpg", size)
{
	contentSize_ = size;

	CGFloat btnY = size.height*2/3;
	CGFloat btnOffsetX = 30;
	CGFloat btnRadius = 40;

	CGFloat offset = 3*btnOffsetX + 4*btnRadius;

	nextController_ = make_shared<NextController>(USize{4U, 4U});
	children_.push_back(nextController_);

	gameField_ = shared_ptr<GameField>(new GameField(size.height, [&]() { return nextController_->NextFigure(); }));
	children_.push_back(gameField_);

	gameField_->SetPosition(CGPointMake(offset, 0));
	nextController_->SetPosition({offset + gameField_->ContentSize().width + Square::SIDE, contentSize_.height - nextController_->ContentSize().height - Square::SIDE});
	
	children_.push_back(unique_ptr<Node>(new Button("rotate-ccw.png", btnRadius, {size.width - (btnOffsetX + 2*btnRadius), btnY}, [&]{ gameField_->Rotate(); })));
	children_.push_back(unique_ptr<Node>(new Button("arrow left.png", btnRadius, {btnOffsetX, btnY}, [&]{ gameField_->MoveLeft(); })));
	children_.push_back(unique_ptr<Node>(new Button("arrow right.png", btnRadius, {2*btnOffsetX + 2*btnRadius, btnY}, [&]{ gameField_->MoveRight(); })));
	children_.push_back(unique_ptr<Node>(new Button("arrow down.png", btnRadius, {btnOffsetX*1.5f + btnRadius, btnY - 2*btnRadius}, [&]{ gameField_->MoveDown(); })));
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
void Scene::SetTouchdownCallback(std::function<void ()> cb)
{
	gameField_->SetTouchdownCallback(cb);
}
