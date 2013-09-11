//
//  GameField.mm
//  Tetris
//
//  Created by cody on 9/10/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "GameField.h"
#include "Sprite.h"

///
GameField::GameField(GLKVector2 position, CGSize size)
{
	this->position = position;
	contentSize = size;

	Sprite* sprite = new Sprite("black-square40.png");
	sprite->position.x = 0;
	sprite->position.y = 0;

	children_.push_back(std::unique_ptr<Node>(sprite));
}
