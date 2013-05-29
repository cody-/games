//
//  BubbleStateAccrescent.cpp
//  Bubbles
//
//  Created by cody on 5/18/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./BubbleStateAccrescent.hpp"
#include "./BubbleStateExploding.hpp"
#include "./BubbleWidget.hpp"
#include "./Settings.hpp"
#include <iostream>

///
BubbleStateAccrescent::BubbleStateAccrescent(BubbleWidget& owner)
	: BubbleState(owner)
	, dr_((float)(Settings::MaxRadius() - owner_.radius_)/Settings::BornTime())
	, dRotation_(Settings::RotationSpeed())
	, ddRotation_(dRotation_*0.8f/Settings::BornTime())
{
}

///
void BubbleStateAccrescent::SetUp()
{
	owner_.MkAggressive();
}

///
void BubbleStateAccrescent::Update(const float dt)
{
	if (owner_.radius_ < Settings::MaxRadius())
	{
		owner_.radius_ += dr_ * dt;
	}
	else
		owner_.SetState<BubbleStateExploding>();

	owner_.rotation_ += dRotation_;
	dRotation_ -= ddRotation_ * dt;
}
