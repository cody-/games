//
//  GameWidget.hpp
//  Bubbles
//
//  Created by cody on 5/18/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Bubbles__GameWidget__
#define __Bubbles__GameWidget__

#include "./Widget.hpp"
#include "./FieldWidget.hpp"
#include "./FieldWidgetContext.hpp"
#include "./TextWidget.hpp"
#include "./LogoWidget.hpp"

///
class GameWidget
	: public Widget
	, public FieldWidgetContext
{
public:
	GameWidget(const unsigned width, const unsigned height);
	void Update(const float dt) override;
	void Draw() override;
	void ResizeScene(const unsigned width, const unsigned height) override;
	void Click(const FPoint& point) override;

	void LastExplosion() override;

private:
	void Start();

	FieldWidget field_;
	LogoWidget logo_;
	TextWidget textField_;
	bool started_;
	unsigned shots_;
};

#endif /* defined(__Bubbles__GameWidget__) */
