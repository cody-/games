//
//  BubbleStateExploding.hpp
//  Bubbles
//
//  Created by cody on 5/18/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Bubbles__BubbleStateExploding__
#define __Bubbles__BubbleStateExploding__

#include "./BubbleState.hpp"

///
class BubbleStateExploding
	: public BubbleState
{
public:
	BubbleStateExploding(BubbleWidget& owner);
	void Update(const float dt) override;

private:
	float countdown_;
	float dRadius_;
};

#endif /* defined(__Bubbles__BubbleStateExploding__) */
