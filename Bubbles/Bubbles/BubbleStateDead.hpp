//
//  BubbleStateDead.hpp
//  Bubbles
//
//  Created by cody on 5/18/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Bubbles__BubbleStateDead__
#define __Bubbles__BubbleStateDead__

#include "./BubbleState.hpp"

///
class BubbleStateDead
	: public BubbleState
{
public:
	BubbleStateDead(BubbleWidget& owner);
	void SetUp() override;
	void Update(const float dt) override;
	void Draw() override;
	bool Dead() const override;
};

#endif /* defined(__Bubbles__BubbleStateDead__) */
