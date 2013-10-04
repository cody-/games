//
//  Border.h
//  Tetris
//
//  Created by cody on 9/11/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__Border__
#define __Tetris__Border__

#include "./Node.h"
#include "./Types.h"

///
class Border
	: public Node
{
public:
	static const unsigned short WIDTH = 1;

	Border(CGPoint position, CGFloat height);
	void Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix) override;

private:
	Tetris::Line line_;
};

#endif /* defined(__Tetris__Border__) */
