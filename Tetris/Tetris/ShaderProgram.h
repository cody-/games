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
	GLboolean useColor;
};

///
class ShaderProgram
{
public:
	ShaderProgram();
	~ShaderProgram();
	bool LoadShaders();
	void Use();

	Uniforms uniforms;
	GLKMatrix4 projectionMatrix;
	GLKMatrix4 mvpMatrix;

private:
	bool CompileShader(GLuint* shader, GLenum type, NSString* file);
	bool LinkProgram(GLuint prog);
	bool ValidateProgram(GLuint prog);

	GLuint handle;
};

#endif
