//
//  GameField.h
//  Tetris
//
//  Created by cody on 9/10/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__GameField__
#define __Tetris__GameField__

#include "./TexturedNode.h"

///
class GameField
	: public TexturedNode
{
public:
	static unsigned int Width();

	GameField(CGPoint position, CGFloat height);
	void Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix) override;

private:
	void NewFigure();

	static const unsigned short RIGHT = 12;
	const unsigned short TOP;
};

#endif /* defined(__Tetris__GameField__) */
