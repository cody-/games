//
//  Sprite.mm
//  Tetris
//
//  Created by cody on 9/9/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#import "Sprite.h"

using namespace std;

///
Sprite::Sprite(const string& fileName)
	: textureInfo_(LoadTexture(fileName))
	, quad_(CGSizeMake(textureInfo_.width, textureInfo_.height))
{
}

///
Sprite::Sprite(const string& fileName, CGSize size)
	: textureInfo_(LoadTexture(fileName))
	, quad_(size)
{
}

///
GLKTextureInfo* Sprite::LoadTexture(const string& fileName)
{
	NSDictionary* options = @{GLKTextureLoaderOriginBottomLeft: @YES};
	NSError* error;
	GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:fileName.c_str()] ofType:nil] options:options error:&error];
	if (textureInfo == nil)
	{
		NSLog(@"Error loading file: %@", [error localizedDescription]);
		throw "Can't load texture";
	}

	return textureInfo;
}

///
void Sprite::Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix)
{
	Node::Render(program, modelViewMatrix);

	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, textureInfo_.name);

	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);

	long offset = (long)&quad_;
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void*)(offset + offsetof(TexturedVertex, geometryVertex)));
	glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void*)(offset + offsetof(TexturedVertex, textureVertex)));

	GLKMatrix4 mvMatrix = GLKMatrix4Multiply(modelViewMatrix, ModelMatrix());
	GLKMatrix4 mvpMatrix = GLKMatrix4Multiply(program.projectionMatrix, mvMatrix);

	glUniformMatrix4fv(program.uniforms.mvpMatrix, 1, NO, mvpMatrix.m);
	glUniform1i(program.uniforms.texSampler, 0);
	glUniform4f(program.uniforms.color, 1.0, 0.0, 0.0, 1.0);

	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}
