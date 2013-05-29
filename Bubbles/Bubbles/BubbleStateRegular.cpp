//
//  BubbleStateRegular.cpp
//  Bubbles
//
//  Created by cody on 5/18/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./BubbleStateRegular.hpp"
#include "./BubbleStateHit.hpp"
#include "./BubbleWidget.hpp"
#include "./BubbleWidgetContext.hpp"
#include "./TailEffect.hpp"
#include "./NullEffect.hpp"
#include "./Settings.hpp"

///
BubbleStateRegular::BubbleStateRegular(BubbleWidget& owner)
	: BubbleState(owner)
{
}

///
void BubbleStateRegular::SetUp()
{
	owner_.SetEffect<TailEffect>();
}

///
void BubbleStateRegular::TearDown()
{
	owner_.SetEffect<NullEffect>();
}

///
void BubbleStateRegular::Update(const float dt)
{
	const FPoint newCenter = Move(owner_.center_, owner_.velocity_, dt);
	if (owner_.CollidesWithVerticalWall(newCenter))		owner_.velocity_.x = -owner_.velocity_.x;
	if (owner_.CollidesWithHorizontalWall(newCenter))	owner_.velocity_.y = -owner_.velocity_.y;
	
	owner_.center_ = Move(owner_.center_, owner_.velocity_, dt);
	owner_.rotation_ += Settings::RotationSpeed();

	auto collision = owner_.CollisionWithAggressiveBubble();
	if (collision != nullptr)
		owner_.SetState(new BubbleStateHit(owner_, *collision));
}

///
inline FPoint BubbleStateRegular::Move(const FPoint& point, const Vector& velocity, const float dt)
{
	return {point.x + velocity.x * dt, point.y + velocity.y * dt};
}
