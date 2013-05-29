//
//  BubbleWidgetContext.hpp
//  Bubbles
//
//  Created by cody on 5/18/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef Bubbles_BubbleWidgetContext_hpp
#define Bubbles_BubbleWidgetContext_hpp

#include "./misc/Geometry.h"

class BubbleWidget;

///
class BubbleWidgetContext
{
public:
	virtual bool CollisionWithVerticalWall(const FPoint& center, const float radius) = 0;
	virtual bool CollisionWithHorizontalWall(const FPoint& center, const float radius) = 0;
	virtual const BubbleWidget* CollisionWithAggressiveBubble(const BubbleWidget* bubble) const = 0;

	virtual void RegisterAggressive(const BubbleWidget* bubble) = 0;
	virtual void UnregisterAggressive(const BubbleWidget* bubble) = 0;
};

#endif
