//
//  BubbleStateAccrescent.hpp
//  Bubbles
//
//  Created by cody on 5/18/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Bubbles__BubbleStateAccrescent__
#define __Bubbles__BubbleStateAccrescent__

#include "./BubbleState.hpp"

///
class BubbleStateAccrescent
	: public BubbleState
{
public:
	BubbleStateAccrescent(BubbleWidget& owner);
	void SetUp() override;
	void Update(const float dt) override;

private:
	float dr_; /// Delta of radius increasing per second
	float dRotation_;
	float ddRotation_;
};

#endif /* defined(__Bubbles__BubbleStateAccrescent__) */
