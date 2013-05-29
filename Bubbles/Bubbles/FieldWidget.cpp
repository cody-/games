//
//  FieldWidget.cpp
//  Bubbles
//
//  Created by cody on 5/17/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./FieldWidget.hpp"
#include "./FieldWidgetContext.hpp"
#include "./misc/Utils.hpp"
#include "./Settings.hpp"

#include <iostream>
#include <random>
#include <OpenGL/glu.h>

using namespace std;

///
FieldWidget::FieldWidget(FieldWidgetContext& context, const unsigned width, const unsigned height)
	: context_(context)
	, width_(width)
	, height_(height)
{
}

///
void FieldWidget::Reset(const unsigned count)
{
	random_device rd;
	mt19937 gn(rd());
	const unsigned r = Settings::MinRadius();
	uniform_int_distribution<> xdist(r, width_ - r);
	uniform_int_distribution<> ydist(r, height_ - r);
	BothSignDistribution vdist(Settings::MinVelocity(), Settings::MaxVelocity());

	bubbles_.clear();
	for (unsigned i = 0; i < count; ++i)
	{
		bubbles_.emplace_back(new BubbleWidget(
			*this,
			{(float)xdist(gn), (float)ydist(gn)},
			{(float)vdist(gn), (float)vdist(gn)}
		));
	}
}

///
Stat FieldWidget::Statistics() const
{
	const unsigned deadBubbles = accumulate(bubbles_.begin(), bubbles_.end(), 0, [](unsigned total, const BubblePtr& bubble) {
		return total + (bubble->Dead() ? 1 : 0);
	});
	return {static_cast<unsigned int>(bubbles_.size()) - 1, deadBubbles - 1};
}

///
void FieldWidget::Update(const float dt)
{
	for_each(bubbles_.begin(), bubbles_.end(), [&](const BubblePtr& bubble) {
		bubble->Update(dt);
	});
}

///
void FieldWidget::Draw()
{
	glLoadIdentity();
	for_each(bubbles_.begin(), bubbles_.end(), [](const BubblePtr& bubble) {
		bubble->Draw();
	});
}

///
void FieldWidget::ResizeScene(const unsigned int width, const unsigned int height)
{
	width_ = width;
	height_ = height;
}

///
void FieldWidget::Click(const FPoint& point)
{
	BubbleWidget* bubble = new BubbleWidget(*this, point);
	bubble->BlowUp();
	bubbles_.emplace_back(bubble);
}

///
bool FieldWidget::CollisionWithVerticalWall(const FPoint& center, const float radius)
{
	return center.x < radius || center.x > width_ - radius;
}

///
bool FieldWidget::CollisionWithHorizontalWall(const FPoint& center, const float radius)
{
	return center.y < radius || center.y > height_ - radius;
}

///
const BubbleWidget* FieldWidget::CollisionWithAggressiveBubble(const BubbleWidget* bubble) const
{
	auto collision = find_if(aggressiveBubbles_.begin(), aggressiveBubbles_.end(), [&](const BubbleWidget* aggressiveBubble){
		return aggressiveBubble->CollidesWith(bubble);
	});

	return aggressiveBubbles_.end() == collision ? nullptr : *collision;
}

///
void FieldWidget::RegisterAggressive(const BubbleWidget* bubble)
{
	aggressiveBubbles_.push_back(bubble);
}

///
void FieldWidget::UnregisterAggressive(const BubbleWidget* bubble)
{
	aggressiveBubbles_.erase(remove(aggressiveBubbles_.begin(), aggressiveBubbles_.end(), bubble), aggressiveBubbles_.end());
	if (aggressiveBubbles_.size() == 0)
		context_.LastExplosion();
}
