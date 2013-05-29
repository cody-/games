//
//  BubbleStateHit.hpp
//  Bubbles
//
//  Created by cody on 5/20/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Bubbles__BubbleStateHit__
#define __Bubbles__BubbleStateHit__

#include "./BubbleState.hpp"

///
class BubbleStateHit
	: public BubbleState
{
public:
	BubbleStateHit(BubbleWidget& owner, const BubbleWidget& baseBubble);
	void Update(const float dt) override;

private:
	unsigned countdown_;
	const BubbleWidget& baseBubble_;
};

#endif /* defined(__Bubbles__BubbleStateHit__) */
