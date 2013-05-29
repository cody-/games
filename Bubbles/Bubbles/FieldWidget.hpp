//
//  FieldWidget.hpp
//  Bubbles
//
//  Created by cody on 5/17/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Bubbles__FieldWidget__
#define __Bubbles__FieldWidget__

#include "./Widget.hpp"
#include "./BubbleWidgetContext.hpp"
#include "./BubbleWidget.hpp"
#include <vector>
#include <memory>

///
struct Stat
{
	unsigned totalBubbles;
	unsigned deadBubbles;
};

class FieldWidgetContext;

class FieldWidget
	: public Widget
	, public BubbleWidgetContext
{
public:
	FieldWidget(FieldWidgetContext& context, const unsigned width, const unsigned height);
	void Update(const float dt) override;
	void Draw() override;
	void ResizeScene(const unsigned width, const unsigned height) override;
	void Click(const FPoint& point) override;

	void Reset(const unsigned count);
	Stat Statistics() const;

	bool CollisionWithVerticalWall(const FPoint& center, const float radius) override;
	bool CollisionWithHorizontalWall(const FPoint& center, const float radius) override;
	const BubbleWidget* CollisionWithAggressiveBubble(const BubbleWidget* bubble) const override;
	void RegisterAggressive(const BubbleWidget* bubble) override;
	void UnregisterAggressive(const BubbleWidget* bubble) override;

private:
	FieldWidgetContext& context_;

	unsigned width_;
	unsigned height_;
	using BubblePtr = std::unique_ptr<BubbleWidget>;
	std::vector<BubblePtr> bubbles_;
	std::vector<const BubbleWidget*> aggressiveBubbles_;
};

#endif /* defined(__Bubbles__FieldWidget__) */
