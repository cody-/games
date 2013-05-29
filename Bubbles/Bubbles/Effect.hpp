//
//  Effect.hpp
//  Bubbles
//
//  Created by cody on 5/21/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef Bubbles_Effect_h
#define Bubbles_Effect_h

#include "./Widget.hpp"

class BubbleWidget;

///
class Effect
	: public Widget
{
protected:
	const BubbleWidget& base_;

public:
	Effect(const BubbleWidget& base) : base_(base) {}
	virtual void Update(const float dt) {}
	virtual void Draw() {}
};

#endif
