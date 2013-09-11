//
//  Square.mm
//  Tetris
//
//  Created by cody on 9/11/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "Square.h"

///
Square::Square()
	: Sprite("black-square40.png", {SIDE, SIDE})
{
}

///
void Square::SetPosition(Game::Point<unsigned short> position)
{
	Sprite::SetPosition(CGPointMake(position.x * SIDE, position.y * SIDE));
}
