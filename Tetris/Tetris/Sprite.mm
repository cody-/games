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
Sprite::Sprite(const string& fileName, const ShaderProgram& program)
	: Node(program)
	, textureInfo_(LoadTexture(fileName))
{
	quad_.bl.geometryVertex = CGPointMake(0, 0);
	quad_.br.geometryVertex = CGPointMake(textureInfo_.width, 0);
	quad_.tl.geometryVertex = CGPointMake(0, textureInfo_.height);
	quad_.tr.geometryVertex = CGPointMake(textureInfo_.width, textureInfo_.height);

	quad_.bl.textureVertex = CGPointMake(0, 0);
	quad_.br.textureVertex = CGPointMake(1, 0);
	quad_.tl.textureVertex = CGPointMake(0, 1);
	quad_.tr.textureVertex = CGPointMake(1, 1);
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
void Sprite::RenderWithModelViewMatrix(const GLKMatrix4& matrix)
{
	Node::RenderWithModelViewMatrix(matrix);

	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, textureInfo_.name);

	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);

	long offset = (long)&quad_;
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void*)(offset + offsetof(TexturedVertex, geometryVertex)));
	glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void*)(offset + offsetof(TexturedVertex, textureVertex)));

	GLKMatrix4 modelViewMatrix = GLKMatrix4Multiply(matrix, ModelMatrix());
	GLKMatrix4 mvpMatrix = GLKMatrix4Multiply(program_.projectionMatrix, modelViewMatrix);

	glUniformMatrix4fv(program_.uniforms.mvpMatrix, 1, NO, mvpMatrix.m);
	glUniform1i(program_.uniforms.texSampler, 0);
	glUniform4f(program_.uniforms.color, 1.0, 0.0, 0.0, 1.0);

	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);
}
