//
//  Square.h
//  Tetris
//
//  Created by cody on 9/11/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__Square__
#define __Tetris__Square__

#include "./Sprite.h"
#include "./Types.h"

///
class Square
	: public Sprite
{
public:
	static const unsigned short SIDE = 40;
	Square();
	void SetPosition(Game::Point<unsigned short> position);
};

#endif /* defined(__Tetris__Square__) */
