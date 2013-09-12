//
//  Button.mm
//  Tetris
//
//  Created by cody on 9/12/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "Button.h"

using namespace std;

///
Button::Button(const string& img, CGFloat radius, CGPoint position, function<void()> action)
	: TexturedNode(img, CGSizeMake(2*radius, 2*radius))
	, action_(action)
{
	position_ = position;
}

///
void Button::Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix)
{
	glUniform1i(program.uniforms.useColor, 0);

	TexturedNode::Render(program, modelViewMatrix);
}

///
bool Button::HandleTap(const CGPoint& point)
{
	if (!CGRectContainsPoint(BoundingBox(), point))
		return false;

	action_();
	return true;
}
