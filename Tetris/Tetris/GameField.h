//
//  GameField.h
//  Tetris
//
//  Created by cody on 9/10/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__GameField__
#define __Tetris__GameField__

#include "./Node.h"

///
class GameField
	: public Node
{
public:
	static unsigned int Width();

	GameField(CGPoint position, CGFloat height);

private:
	void NewFigure();

	static const unsigned short RIGHT = 11;
	const unsigned short TOP;
};

#endif /* defined(__Tetris__GameField__) */
