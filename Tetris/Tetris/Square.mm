//
//  Square.mm
//  Tetris
//
//  Created by cody on 9/11/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "Square.h"

///
Square::Square(UPoint position, GLKVector3 color)
	: TexturedNode("black-square32.png", {SIDE, SIDE})
	, color_(color)
{
	SetPosition(position);
}

///
void Square::Move(int dx, int dy)
{
	SetPosition({position_.x + dx, position_.y + dy});
}

///
void Square::SetPosition(UPoint position)
{
	position_ = position;
	TexturedNode::SetPosition(CGPointMake(position.x * SIDE, position.y * SIDE));
}

///
void Square::Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix)
{
	glUniform1i(program.uniforms.useColor, 1);
	glUniform4f(program.uniforms.color, color_.r, color_.g, color_.b, 1.0);

	TexturedNode::Render(program, modelViewMatrix);
}
