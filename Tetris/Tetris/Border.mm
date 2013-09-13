//
//  Border.cpp
//  Tetris
//
//  Created by cody on 9/11/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "Border.h"

///
Border::Border(CGPoint position, CGFloat height)
	: line_({position, {position.x, position.y + height}})
{
	SetPosition(position);
	contentSize_ = CGSizeMake(WIDTH, height);
}

///
void Border::Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix)
{
	Node::Render(program, modelViewMatrix);

	glDisable(GL_TEXTURE_2D);
	glBindTexture(GL_TEXTURE_2D, 0);

	glLineWidth(WIDTH);

	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(CGPoint), &line_);

	GLKMatrix4 mvMatrix = GLKMatrix4Multiply(modelViewMatrix, ModelMatrix());
	GLKMatrix4 mvpMatrix = GLKMatrix4Multiply(program.projectionMatrix, mvMatrix);

	glUniformMatrix4fv(program.uniforms.mvpMatrix, 1, NO, mvpMatrix.m);
	glUniform4f(program.uniforms.color, 0.5, 0.5, 0.5, 1.0);
	glUniform1i(program.uniforms.useColor, 1);

	glDrawArrays(GL_LINES, 0, 2);
}
