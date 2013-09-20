//
//  Square.h
//  Tetris
//
//  Created by cody on 9/11/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__Square__
#define __Tetris__Square__

#include "./TexturedNode.h"
#include "./Types.h"

///
class Square
	: public TexturedNode
{
public:
	static const unsigned short SIDE = 32;
	Square(UPoint position, GLKVector3 color);
	void Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix) override;

	void Move(int dx, int dy);

private:
	void SetPosition(UPoint position);

	UPoint position_;
	const GLKVector3 color_;
};

#endif /* defined(__Tetris__Square__) */
