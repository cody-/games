//
//  TexturedNode.h
//  Tetris
//
//  Created by cody on 9/9/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__TexturedNode__
#define __Tetris__TexturedNode__

#import "./Node.h"
#include "./TexturedQuad.h"
#include <string>

#import <GLKit/GLKit.h>

enum class TextureMode {
	STRETCH,
	REPEAT
};

///
class TexturedNode
	: public Node
{
public:
	TexturedNode(const std::string& fileName);
	TexturedNode(const std::string& fileName, CGSize size, TextureMode mode = TextureMode::STRETCH);
	void Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix) override;

protected:
	GLKTextureInfo* textureInfo_;
	TexturedQuad quad_;
	TextureMode texMode_;
};

#endif
