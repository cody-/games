//
//  GameWidget.cpp
//  Bubbles
//
//  Created by cody on 5/18/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./GameWidget.hpp"
#include "./misc/Resources.h"
#include "./Settings.hpp"

using namespace std;

///
GameWidget::GameWidget(const unsigned width, const unsigned height)
	: field_(*this, width, height)
	, logo_({width/2, height/2})
	, textField_({width/2, height/2})
	, started_(false)
	, shots_(Settings::UserShots())
{
	glShadeModel(GL_SMOOTH);
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	glClearDepth(1.0f);
	glDisable(GL_DEPTH_TEST);
	glEnable(GL_BLEND);
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_CONSTANT_ALPHA);
	glHint(GL_POINT_SMOOTH_HINT, GL_NICEST);

	textField_ << "START";
}

///
void GameWidget::Update(const float dt)
{
	if (started_)
		field_.Update(dt);
}

///
void GameWidget::Draw()
{
	field_.Draw();
	if (!started_)
	{
		logo_.Draw();
		textField_.Draw();
	}
}

///
void GameWidget::ResizeScene(const unsigned width, const unsigned height)
{
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();

	glOrtho(0.0f, width, 0.0f, height, -1.0f, 1.0f);

	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();

	field_.ResizeScene(width, height);
}

///
void GameWidget::Click(const FPoint& point)
{
	if (!started_)
	{
		Start();
		return;
	}

	if (shots_ > 0)
	{
		--shots_;
		field_.Click(point);
	}
}

///
void GameWidget::Start()
{
	field_.Reset(Settings::BubblesCount());
	shots_ = Settings::UserShots();
	started_ = true;
}

/// Game over
void GameWidget::LastExplosion()
{
	const Stat stat = field_.Statistics();
	textField_.Clear() << "Score: " + to_string(stat.deadBubbles) + "/" + to_string(stat.totalBubbles) << "AGAIN";
	started_ = false;
}
