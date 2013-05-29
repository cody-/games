//
//  BubbleStateRegular.hpp
//  Bubbles
//
//  Created by cody on 5/18/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Bubbles__BubbleStateRegular__
#define __Bubbles__BubbleStateRegular__

#include "./BubbleState.hpp"
#include "./misc/Geometry.h"

///
class BubbleStateRegular
	: public BubbleState
{
public:
	BubbleStateRegular(BubbleWidget& owner);
	void SetUp() override;
	void TearDown() override;
	void Update(const float dt) override;

private:
	static FPoint Move(const FPoint& point, const Vector& velocity, const float dt);
};

#endif /* defined(__Bubbles__BubbleStateRegular__) */
