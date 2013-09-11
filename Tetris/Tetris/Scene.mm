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
	contentSize = size;

	GameField* field = new GameField(GLKVector2Make(size.width/4, 0), CGSizeMake(size.width/2, size.height));
	children_.push_back(std::unique_ptr<Node>(field));
}
