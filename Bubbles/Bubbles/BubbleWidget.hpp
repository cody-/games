//
//  BubbleWidget.hpp
//  Bubbles
//
//  Created by cody on 5/17/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Bubbles__BubbleWidget__
#define __Bubbles__BubbleWidget__

#include "./ImgWidget.hpp"
#include "./BubbleState.hpp"
#include "./Effect.hpp"

class BubbleWidgetContext;

///
class BubbleWidget
	: public ImgWidget
{
	friend class BubbleState;
	friend class BubbleStateRegular;
	friend class BubbleStateHit;
	friend class BubbleStateAccrescent;
	friend class BubbleStateExploding;
	friend class BubbleStateDead;

public:
	BubbleWidget(BubbleWidgetContext& field, const FPoint& center, const Vector& velocity);
	BubbleWidget(BubbleWidgetContext& field, const FPoint& center);
	
	void Update(const float dt) override;
	void Draw() override;

	void BlowUp();
	bool CollidesWith(const BubbleWidget* bubble) const;
	bool Dead() const;

	FPoint Center() const;
	Vector Velocity() const;
	float Radius() const;

private:
	void SetState(BubbleState* state);
	template <class T> void SetState() { SetState(new T(*this)); }

	void SetEffect(Effect* effect);
	template <class T> void SetEffect() { SetEffect(new T(*this)); }

	void MkAggressive();
	void MkNonAggressive();
	const BubbleWidget* CollisionWithAggressiveBubble() const;
	bool CollidesWithVerticalWall(const FPoint& newCenter) const;
	bool CollidesWithHorizontalWall(const FPoint& newCenter) const;

	BubbleWidgetContext& field_;

	FPoint center_;
	float radius_;
	Vector velocity_;
	float rotation_;

	std::unique_ptr<Effect> effect_;
	std::unique_ptr<BubbleState> state_;
};

#endif /* defined(__Bubbles__BubbleWidget__) */
