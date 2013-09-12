//
//  Square.mm
//  Tetris
//
//  Created by cody on 9/11/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "Square.h"

///
Square::Square(UPoint position)
	: TexturedNode("black-square32.png", {SIDE, SIDE})
{
	SetPosition(position);
}

///
void Square::SetPosition(UPoint position)
{
	TexturedNode::SetPosition(CGPointMake(position.x * SIDE, position.y * SIDE));
}

///
void Square::Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix)
{
	glUniform1i(program.uniforms.useColor, 1);
	glUniform4f(program.uniforms.color, 1.0, 0.0, 0.0, 1.0);

	TexturedNode::Render(program, modelViewMatrix);
}
