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
GameField::GameField(const ShaderProgram& program, GLKVector2 position, CGSize size)
	: Node(program)
{
	this->position = position;
	contentSize = size;

	Sprite* sprite = new Sprite("black-square40.png", program_);
	sprite->position.x = 0;
	sprite->position.y = 0;

	children_.push_back(std::unique_ptr<Node>(sprite));
}
