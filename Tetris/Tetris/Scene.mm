//
//  Scene.mm
//  Tetris
//
//  Created by cody on 9/9/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "Scene.h"
#include "GameField.h"

///
Scene::Scene(const CGSize& size)
{
	contentSize_ = size;

	CGFloat offset = (size.width - GameField::Width())/2;
	GameField* field = new GameField(CGPointMake(offset, 0), size.height);
	children_.push_back(std::unique_ptr<Node>(field));
}
