//
//  BubbleStateHit.cpp
//  Bubbles
//
//  Created by cody on 5/20/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./BubbleStateHit.hpp"
#include "./BubbleWidget.hpp"
#include "./BubbleStateAccrescent.hpp"
#include <math.h>

///
BubbleStateHit::BubbleStateHit(BubbleWidget& owner, const BubbleWidget& baseBubble)
	: BubbleState(owner)
	, countdown_(1)
	, baseBubble_(baseBubble)
{
}

/// Sticky effect
void BubbleStateHit::Update(const float dt)
{
	if (countdown_-- == 0)
	{
		owner_.SetState<BubbleStateAccrescent>();
		return;
	}
	
	const float d = owner_.radius_ / sqrt(distance2(baseBubble_.center_, owner_.center_));
	const float dx = (baseBubble_.center_.x - owner_.center_.x) * d;
	const float dy = (baseBubble_.center_.y - owner_.center_.y) * d;

	owner_.radius_ *= 0.5f;
	owner_.center_.x += dx;
	owner_.center_.y += dy;
}
