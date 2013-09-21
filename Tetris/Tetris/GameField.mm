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
GameField::GameField(CGFloat height, function<shared_ptr<SingleFigure>()> figureGenerator)
	: TexturedNode("black-square32.png", {static_cast<CGFloat>(Width()), height}, TextureMode::REPEAT)
	, TOP(height/Square::SIDE - 1)
	, figureGenerator_(figureGenerator)
	, touchdownCallback_(nullptr)
	, touchdown_(false)
{
	auto lBorder = new Border({-Border::WIDTH, 0}, contentSize_.height);
	children_.push_back(shared_ptr<Node>(lBorder));
	auto rBorder = new Border({contentSize_.width, 0}, contentSize_.height);
	children_.push_back(shared_ptr<Node>(rBorder));

	NewFigure();
	figureStack_ = make_shared<FigureStack>(RIGHT + 1U);
	figureStack_->SetPosition({0, 0});
	children_.push_back(figureStack_);
}

///
void GameField::NewFigure()
{
	activeFigure_ = figureGenerator_();
	activeFigure_->SetPosition({RIGHT/2 - static_cast<int>(activeFigure_->Size().w)/2, TOP - (static_cast<int>(activeFigure_->Size().h) - 1)});
	children_.push_back(activeFigure_);
}

///
void GameField::DropFigure()
{
	children_.erase(remove(begin(children_), end(children_), activeFigure_));
	figureStack_->Push(*activeFigure_);
	
	auto linesCount = figureStack_->RmFullLines();
	if (linesCount && linesCallback_)
		linesCallback_(linesCount);
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

	if (touchdown_)
	{
		if (touchdownCallback_)
			touchdownCallback_();
		touchdown_ = false;
		DropFigure();
		NewFigure();
	}

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
		activeFigure_->MoveLeft([&](const GridPoint& p) { return ValidateMove(p); });
	});
}

///
void GameField::MoveRight()
{
	lock_guard<mutex> lock(actionsAccess_);
	actions_.push_back([&]{
		activeFigure_->MoveRight([&](const GridPoint& p) { return ValidateMove(p); });
	});
}

///
void GameField::MoveDown()
{
	lock_guard<mutex> lock(actionsAccess_);
	actions_.push_back([&]{
		activeFigure_->MoveDown([&](const GridPoint& p) { return ValidateMoveDown(p); });
	});
}

///
void GameField::Rotate()
{
	lock_guard<mutex> lock(actionsAccess_);
	actions_.push_back([&]{
		activeFigure_->Rotate([&](const GridPoint& p, const USize& s) { return ValidateRotation(p, s); });
	});
}

///
bool GameField::ValidateMove(const GridPoint& newPosition) const
{
	const USize sz = activeFigure_->Size();
	const UPoint rightTop = {newPosition.x + sz.w - 1, newPosition.y + sz.h - 1};
	return newPosition.x >= 0 && rightTop.x <= RIGHT && !figureStack_->CollidesWith(*activeFigure_, newPosition);
}

///
bool GameField::ValidateMoveDown(const GridPoint& newPosition) const
{
	touchdown_ = newPosition.y < 0 || figureStack_->CollidesWith(*activeFigure_, newPosition);
	return !touchdown_;
}

///
bool GameField::ValidateRotation(const GridPoint& newPosition, const USize& newSize) const
{
	const UPoint rightTop = {newPosition.x + newSize.w - 1, newPosition.y + newSize.h - 1};
	return newPosition.x >= 0 && rightTop.x <= RIGHT
		&& newPosition.y >= 0 && rightTop.y <= TOP;
}
