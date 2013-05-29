//
//  BubbleWidget.cpp
//  Bubbles
//
//  Created by cody on 5/17/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./BubbleWidget.hpp"
#include "./BubbleWidgetContext.hpp"
#include "./BubbleStateRegular.hpp"
#include "./BubbleStateAccrescent.hpp"
#include "./NullEffect.hpp"
#include "./Settings.hpp"

using namespace std;

///
BubbleWidget::BubbleWidget(BubbleWidgetContext& field, const FPoint& center, const Vector& velocity)
	: ImgWidget("FireBall.png", GL_RGBA)
	, field_(field)
	, center_(center)
	, radius_(Settings::MinRadius())
	, velocity_(velocity)
	, rotation_(0)
{
	SetEffect<NullEffect>();
	SetState<BubbleStateRegular>();
}

///
BubbleWidget::BubbleWidget(BubbleWidgetContext& field, const FPoint& center)
	: BubbleWidget(field, center, {0, 0})
{
}

///
void BubbleWidget::Update(const float dt)
{
	state_->Update(dt);
	effect_->Update(dt);
}

///
void BubbleWidget::Draw()
{
	state_->Draw();
	effect_->Draw();
}

///
void BubbleWidget::BlowUp()
{
	SetState<BubbleStateAccrescent>();
}

///
bool BubbleWidget::CollidesWith(const BubbleWidget* bubble) const
{
	return distance2(center_, bubble->center_) <= sqr(radius_ + bubble->radius_);
}

///
bool BubbleWidget::Dead() const
{
	return state_->Dead();
}

///
FPoint BubbleWidget::Center() const
{
	return center_;
}

///
Vector BubbleWidget::Velocity() const
{
	return velocity_;
}

///
float BubbleWidget::Radius() const
{
	return radius_;
}

///
void BubbleWidget::SetState(BubbleState* state)
{
	if (state_)
		state_->TearDown();
	
	state_.reset(state);
	state_->SetUp();
}

///
void BubbleWidget::SetEffect(Effect* effect)
{
	effect_.reset(effect);
}

///
void BubbleWidget::MkAggressive()
{
	field_.RegisterAggressive(this);
}

///
void BubbleWidget::MkNonAggressive()
{
	field_.UnregisterAggressive(this);
}

///
const BubbleWidget* BubbleWidget::CollisionWithAggressiveBubble() const
{
	return field_.CollisionWithAggressiveBubble(this);
}

///
bool BubbleWidget::CollidesWithHorizontalWall(const FPoint& newCenter) const
{
	return field_.CollisionWithHorizontalWall(newCenter, radius_);
}

///
bool BubbleWidget::CollidesWithVerticalWall(const FPoint& newCenter) const
{
	return field_.CollisionWithVerticalWall(newCenter, radius_);
}
