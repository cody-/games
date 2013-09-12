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
	Square(UPoint position);
	void Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix) override;

private:
	void SetPosition(UPoint position);
};

#endif /* defined(__Tetris__Square__) */
