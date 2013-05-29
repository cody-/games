//
//  BubbleState.hpp
//  Bubbles
//
//  Created by cody on 5/18/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef Bubbles_BubbleState_hpp
#define Bubbles_BubbleState_hpp

class BubbleWidget;

///
class BubbleState
{
protected:
	BubbleWidget& owner_;

public:
	BubbleState(BubbleWidget& owner);
	virtual void SetUp();
	virtual void TearDown();
	virtual void Update(const float dt);
	virtual void Draw();
	virtual bool Dead() const;
};

#endif
