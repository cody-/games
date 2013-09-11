//
//  TexturedQuad.h
//  Tetris
//
//  Created by cody on 9/9/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef Tetris_TexturedQuad_h
#define Tetris_TexturedQuad_h

#include <GLKit/GLKit.h>

///
struct TexturedVertex
{
	CGPoint geometryVertex;
	CGPoint textureVertex;
};

///
class TexturedQuad
{
public:
	TexturedQuad(CGSize size);

	TexturedVertex bl;
	TexturedVertex br;
	TexturedVertex tl;
	TexturedVertex tr;
};

#endif
