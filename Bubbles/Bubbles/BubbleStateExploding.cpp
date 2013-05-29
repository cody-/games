//
//  BubbleStateExploding.cpp
//  Bubbles
//
//  Created by cody on 5/18/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./BubbleStateExploding.hpp"
#include "./BubbleStateDead.hpp"
#include "./BubbleWidget.hpp"
#include "./Settings.hpp"
#include <iostream>

///
BubbleStateExploding::BubbleStateExploding(BubbleWidget& owner)
	: BubbleState(owner)
	, countdown_(Settings::LifeTime())
	, dRadius_((Settings::BoomRadius() - Settings::MaxRadius())/Settings::LifeTime())
{
}

///
void BubbleStateExploding::Update(const float dt)
{
	if (countdown_ <= 0)
	{
		owner_.SetState<BubbleStateDead>();
		return;
	}

	countdown_ -= dt;
	owner_.radius_ += dRadius_ * dt;
}
