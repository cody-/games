//
//  Scene.mm
//  Tetris
//
//  Created by cody on 9/9/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "Scene.h"
#import "Sprite.h"

///
Scene::Scene(const CGSize& size, const ShaderProgram& program)
	: Node(program)
{
	contentSize = size;

	Sprite* sprite = new Sprite("black-square40.png", program_);
	sprite->position.x = size.width/2;
	sprite->position.y = size.height/2;

	children_.push_back(std::unique_ptr<Node>(sprite));
}
