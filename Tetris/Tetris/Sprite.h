//
//  Sprite.h
//  Tetris
//
//  Created by cody on 9/9/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#import "./Node.h"
#include "./TexturedQuad.h"
#include <string>

#import <GLKit/GLKit.h>

///
class Sprite
	: public Node
{
public:
	Sprite(const std::string& fileName, const ShaderProgram& program);
	void RenderWithModelViewMatrix(const GLKMatrix4& matrix) override;

private:
	static GLKTextureInfo* LoadTexture(const std::string& fileName);

	GLKTextureInfo* textureInfo_;
	TexturedQuad quad_;
};
