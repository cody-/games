//
//  GameField.mm
//  Tetris
//
//  Created by cody on 9/10/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "GameField.h"
#include "./Border.h"
#include "./Figure.h"
#include "./Square.h"

using namespace std;

///
unsigned int GameField::Width()
{
	return (RIGHT + 1) * Square::SIDE;
}

///
GameField::GameField(CGPoint position, CGFloat height)
	: TexturedNode("black-square32.png", {static_cast<CGFloat>(Width()), height}, TextureMode::REPEAT)
	, TOP(height/Square::SIDE - 1)
{
	SetPosition(position);

	auto lBorder = new Border({-Border::WIDTH, 0}, contentSize_.height);
	children_.push_back(shared_ptr<Node>(lBorder));
	auto rBorder = new Border({contentSize_.width, 0}, contentSize_.height);
	children_.push_back(shared_ptr<Node>(rBorder));

	NewFigure();
}

///
void GameField::NewFigure()
{
	activeFigure_ = make_shared<Figure>(UPoint{RIGHT/2, TOP});
	children_.push_back(shared_ptr<Node>(activeFigure_));
}

///
void GameField::Update(float dt)
{
	lock_guard<mutex> lock(actionsAccess_);
	for(auto action : actions_)
	{
		action();
	}
	actions_.clear();

	TexturedNode::Update(dt);
}

///
void GameField::Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix)
{
	glUniform1i(program.uniforms.useColor, 1);
	glUniform4f(program.uniforms.color, 1.0, 1.0, 1.0, 0.25);

	TexturedNode::Render(program, modelViewMatrix);
}

///
void GameField::MoveLeft()
{
	lock_guard<mutex> lock(actionsAccess_);
	actions_.push_back([&]{
		activeFigure_->MoveLeft([&](const UPoint& p) { return ValidateMove(p); });
	});
}

///
void GameField::MoveRight()
{
	lock_guard<mutex> lock(actionsAccess_);
	actions_.push_back([&]{
		activeFigure_->MoveRight([&](const UPoint& p) { return ValidateMove(p); });
	});
}

///
void GameField::MoveDown()
{
	lock_guard<mutex> lock(actionsAccess_);
	actions_.push_back([&]{
		activeFigure_->MoveDown([&](const UPoint& p) { return ValidateMove(p); });
	});
}

///
void GameField::Rotate()
{
	lock_guard<mutex> lock(actionsAccess_);
	actions_.push_back([&]{
		activeFigure_->Rotate([&](const UPoint& p, const USize& s) { return ValidateRotation(p, s); });
	});
}

///
bool GameField::ValidateMove(const UPoint& newPosition) const
{
	const USize sz = activeFigure_->Size();
	const UPoint rightTop = {newPosition.x + sz.w - 1, newPosition.y + sz.h - 1};
	return rightTop.x > newPosition.x && rightTop.x <= RIGHT
		&& rightTop.y > newPosition.y; // no need to check rightTop.y <= TOP - no move up
}

///
bool GameField::ValidateRotation(const UPoint& newPosition, const USize& newSize) const
{
	const UPoint rightTop = {newPosition.x + newSize.w - 1, newPosition.y + newSize.h - 1};
	return rightTop.x > newPosition.x && rightTop.x <= RIGHT
		&& rightTop.y > newPosition.y && rightTop.y <= TOP;
}


