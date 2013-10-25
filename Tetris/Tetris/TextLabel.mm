//
//  TextLabel.mm
//  Tetris
//
//  Created by cody on 9/21/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./TextLabel.h"
#include "./TextureLoader.h"

using namespace std;

///
TextLabel::TextLabel(string label, string fontName, unsigned fontSize, const GLKVector3& color)
	: TexturedNode(TextureLoader::Instance()->GetTextTexture(label, fontName, fontSize))
	, textColor_(color)
{
}

///
void TextLabel::Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix)
{
	glUniform1i(program.uniforms.useColor, 1);
	glUniform4f(program.uniforms.color, textColor_.r, textColor_.g, textColor_.b, 1.0);

	TexturedNode::Render(program, modelViewMatrix);
}
