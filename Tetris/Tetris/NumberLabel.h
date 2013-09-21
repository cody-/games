//
//  NumberLabel.h
//  Tetris
//
//  Created by cody on 9/21/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__NumberLabel__
#define __Tetris__NumberLabel__

#include "./Node.h"
#include "./TexturedQuad.h"
#include <vector>

/// Font must be mono-width
class NumberLabel
	: public Node
{
public:
	NumberLabel(unsigned initialVal, std::string fontName, unsigned fontSize);
	void Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix) override;

	unsigned Val() const { return val_; }
	void SetVal(unsigned val);

private:
	void UpdateVertices();
	static std::vector<unsigned> SplitNumber(unsigned number);

	GLKTextureInfo* textureInfo_;
	const CGSize symbolSize_;
	unsigned val_;
	std::vector<TexturedVertex> vertices_;
};

#endif /* defined(__Tetris__NumberLabel__) */
