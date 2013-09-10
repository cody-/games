//
//  ShaderProgram.h
//  Tetris
//
//  Created by cody on 9/9/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef Tetris_ShaderProgram_h
#define Tetris_ShaderProgram_h

#import <GLKit/GLKit.h>

///
struct Uniforms
{
	GLint mvpMatrix;
	GLint texSampler;
	GLint color;
};

///
struct ShaderProgram
{
	Uniforms uniforms;
	GLKMatrix4 projectionMatrix;
	GLKMatrix4 mvpMatrix;
};

#endif
