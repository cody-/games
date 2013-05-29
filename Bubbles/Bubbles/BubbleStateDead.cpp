//
//  BubbleStateDead.cpp
//  Bubbles
//
//  Created by cody on 5/18/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./BubbleStateDead.hpp"
#include "./BubbleWidget.hpp"

///
BubbleStateDead::BubbleStateDead(BubbleWidget& owner)
	: BubbleState(owner)
{
}

///
void BubbleStateDead::SetUp()
{
	owner_.MkNonAggressive();
}

///
void BubbleStateDead::Update(const float dt)
{
}

///
void BubbleStateDead::Draw()
{
	// Do nothing
}

///
bool BubbleStateDead::Dead() const
{
	return true;
}
