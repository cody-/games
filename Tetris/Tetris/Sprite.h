//
//  Sprite.h
//  Tetris
//
//  Created by cody on 9/9/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__Sprite__
#define __Tetris__Sprite__

#import "./Node.h"
#include "./TexturedQuad.h"
#include <string>

#import <GLKit/GLKit.h>

///
class Sprite
	: public Node
{
public:
	Sprite(const std::string& fileName);
	void Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix) override;

private:
	static GLKTextureInfo* LoadTexture(const std::string& fileName);

	GLKTextureInfo* textureInfo_;
	TexturedQuad quad_;
};

#endif
