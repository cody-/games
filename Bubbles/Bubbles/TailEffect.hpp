//
//  TailEffect.hpp
//  Bubbles
//
//  Created by cody on 5/21/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Bubbles__TailEffect__
#define __Bubbles__TailEffect__

#include "./Effect.hpp"

class BubbleWidget;

///
class TailEffect
	: public Effect
{
public:
	TailEffect(const BubbleWidget& base);
	void Draw() override;
};

#endif /* defined(__Bubbles__TailEffect__) */
