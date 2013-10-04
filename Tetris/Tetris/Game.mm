//
//  Game.mm
//  Tetris
//
//  Created by cody on 10/3/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./Game.h"
#include "./GameField.h"
#include "./InfoPanel.h"

using namespace std;

namespace
{
	const float BASE_SPEED = 0.5f;
}

///
Game::Game(GameField& gameField, InfoPanel& infoPanel)
	: gameField_(gameField)
	, infoPanel_(infoPanel)
	, touchdownCallback_(nullptr)
	, timeSinceLastMoveDown_(0.0f)
	, touchdown_(false)
	, linesCounter_(0)
	, paused_(false)
{
	gameField_.SetTouchdownCallback([&]{ TouchDown(); });
	gameField_.SetLinesCallback([&](unsigned linesCount) { UpdateLines(linesCount); });
	SetSpeed(1U);
}

///
void Game::Update(float dt)
{
	if (paused_)
		return;

	PerformActions();

	timeSinceLastMoveDown_ += dt;
	if (timeSinceLastMoveDown_ >= movePeriodSec_)
	{
		gameField_.MoveDown();
		timeSinceLastMoveDown_ = 0.0f;
	}

	if (touchdown_)
	{
		touchdown_ = false;
		if (touchdownCallback_)
			touchdownCallback_();

		gameField_.DropFigure();
		gameField_.NewFigure();
	}
}

///
void Game::AddAction(function<void()> action)
{
	if (paused_)
		return;

	lock_guard<mutex> lock(actionsAccess_);
	actions_.push_back(action);
}

///
void Game::PerformActions()
{
	lock_guard<mutex> lock(actionsAccess_);
	for(auto action : actions_)
	{
		action();
	}
	actions_.clear();
}

///
void Game::MoveLeft()
{
	AddAction([&]{ gameField_.MoveLeft(); });
}

///
void Game::MoveRight()
{
	AddAction([&]{ gameField_.MoveRight(); });
}

///
void Game::MoveDown()
{
	AddAction([&]{ gameField_.MoveDown(); });
}

///
void Game::Rotate()
{
	AddAction([&]{ gameField_.Rotate(); });
}

///
void Game::Pause()
{
	paused_ = !paused_;
}

///
void Game::SetSpeed(unsigned speedLevel)
{
	speedLevel_ = speedLevel;
	infoPanel_.SetSpeed(speedLevel_);
	movePeriodSec_ = 1.0f/(BASE_SPEED + static_cast<float>(speedLevel_));
}

///
void Game::TouchDown()
{
	touchdown_ = true;
	if (touchdownCallback_)
		touchdownCallback_();
}

///
void Game::UpdateLines(unsigned int diff)
{
	linesCounter_ += diff;
	infoPanel_.SetLines(linesCounter_);
}
