//
//  TexturedNode.mm
//  Tetris
//
//  Created by cody on 9/9/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#import "./TexturedNode.h"

using namespace std;

///
TexturedNode::TexturedNode(const string& fileName)
	: textureInfo_(LoadTexture(fileName))
	, quad_(CGSizeMake(textureInfo_.width, textureInfo_.height))
	, texMode_(TextureMode::STRETCH)
{
	contentSize_ = CGSizeMake(textureInfo_.width, textureInfo_.height);
}

///
TexturedNode::TexturedNode(const string& fileName, CGSize size, TextureMode mode)
	: textureInfo_(LoadTexture(fileName))
	, quad_(size)
	, texMode_(mode)
{
	contentSize_ = size;
	if (mode == TextureMode::REPEAT)
	{
		quad_.br.textureVertex.x = contentSize_.width/textureInfo_.width;
		quad_.tl.textureVertex.y = contentSize_.height/textureInfo_.height;
		quad_.tr.textureVertex.x = contentSize_.width/textureInfo_.width;
		quad_.tr.textureVertex.y = contentSize_.height/textureInfo_.height;
	}
}

///
GLKTextureInfo* TexturedNode::LoadTexture(const string& fileName)
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
void TexturedNode::Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix)
{
	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, textureInfo_.name);

	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR); 
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

	if (texMode_ == TextureMode::REPEAT)
	{
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT);
		glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_REPEAT);
	}

	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);

	long offset = (long)&quad_;
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void*)(offset + offsetof(TexturedVertex, geometryVertex)));
	glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void*)(offset + offsetof(TexturedVertex, textureVertex)));

	GLKMatrix4 mvMatrix = GLKMatrix4Multiply(modelViewMatrix, ModelMatrix());
	GLKMatrix4 mvpMatrix = GLKMatrix4Multiply(program.projectionMatrix, mvMatrix);

	glUniformMatrix4fv(program.uniforms.mvpMatrix, 1, NO, mvpMatrix.m);
	glUniform1i(program.uniforms.texSampler, 0);

	glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

	Node::Render(program, modelViewMatrix);
}
