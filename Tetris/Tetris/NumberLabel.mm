//
//  NumberLabel.mm
//  Tetris
//
//  Created by cody on 9/21/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "NumberLabel.h"
#include "./TextureLoader.h"
#include <iostream>

using namespace std;

///
NumberLabel::NumberLabel(unsigned initialVal, string fontName, unsigned fontSize)
	: textureInfo_(TextureLoader::Instance()->GetTextTexture("0123456789", fontName, fontSize))
	, symbolSize_({textureInfo_.width/10.0f, static_cast<CGFloat>(textureInfo_.height)})
	, val_(initialVal)
{
	contentSize_.height = symbolSize_.height;
	UpdateVertices();
}

///
void NumberLabel::Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix)
{
	Node::Render(program, modelViewMatrix);

	glActiveTexture(GL_TEXTURE0);
	glBindTexture(GL_TEXTURE_2D, textureInfo_.name);

	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR); 
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

	glEnableVertexAttribArray(GLKVertexAttribPosition);
	glEnableVertexAttribArray(GLKVertexAttribTexCoord0);

	long offset = (long)&vertices_[0];
	glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void*)(offset + offsetof(TexturedVertex, geometryVertex)));
	glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(TexturedVertex), (void*)(offset + offsetof(TexturedVertex, textureVertex)));

	GLKMatrix4 mvMatrix = GLKMatrix4Multiply(modelViewMatrix, ModelMatrix());
	GLKMatrix4 mvpMatrix = GLKMatrix4Multiply(program.projectionMatrix, mvMatrix);

	glUniformMatrix4fv(program.uniforms.mvpMatrix, 1, NO, mvpMatrix.m);
	glUniform1i(program.uniforms.texSampler, 0);

	glDrawArrays(GL_TRIANGLES, 0, vertices_.size());

	Node::Render(program, modelViewMatrix);
}

///
void NumberLabel::SetVal(unsigned val)
{
	val_ = val;
	UpdateVertices();
}

///
void NumberLabel::UpdateVertices()
{
	vertices_.clear();
	auto pieces = SplitNumber(val_);

	for (size_t i = 0; i < pieces.size(); ++i)
	{
		auto n = pieces[i];
		vertices_.push_back({{i * symbolSize_.width, 0}, {n/10.0f, 0}});
		for (size_t j = 0; j < 2; ++j)
		{
			vertices_.push_back({{i * symbolSize_.width, symbolSize_.height}, {n/10.0f, 1.0f}});
			vertices_.push_back({{(i + 1) * symbolSize_.width, 0}, {(n + 1)/10.0f, 0}});
		}
		vertices_.push_back({{(i + 1) * symbolSize_.width, symbolSize_.height}, {(n + 1)/10.0f, 1.0f}});
	}

	contentSize_.width = ((vertices_.size() - 2)/2) * symbolSize_.width;

//	cout << "Size: " << contentSize_.width << "x" << contentSize_.height << endl;
//	for (auto v : vertices_)
//	{
//		cout << "gv = {" << v.geometryVertex.x << ", " << v.geometryVertex.y << "}, tv = {" << v.textureVertex.x << ", " << v.textureVertex.y << "}" << endl;
//	}
}

///
vector<unsigned> NumberLabel::SplitNumber(unsigned number)
{
	if (number < 10)
		return {number};

	auto result = SplitNumber(number/10);
	result.push_back(number % 10);
	return result;
}
