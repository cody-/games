//
//  Widget.hpp
//  Bubbles
//
//  Created by cody on 5/17/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef Bubbles_Widget_hpp
#define Bubbles_Widget_hpp

#include "./misc/Geometry.h"

///
class Widget
{
public:
	virtual ~Widget() {}

	virtual void Update(const float dt) {}
	virtual void Draw() {}
	virtual void ResizeScene(const unsigned width, const unsigned height) {}
	virtual void Click(const FPoint& point) {}
};

#endif
