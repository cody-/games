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
	GameField(const ShaderProgram& program, GLKVector2 position, CGSize size);
};

#endif /* defined(__Tetris__GameField__) */
