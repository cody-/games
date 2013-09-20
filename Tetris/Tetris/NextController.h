//
//  NextController.h
//  Tetris
//
//  Created by cody on 9/19/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__NextController__
#define __Tetris__NextController__

#include "./TexturedNode.h"
#include "./Types.h"
#include "./SingleFigure.h"
#include <memory>

///
class NextController
	: public TexturedNode
{
public:
	NextController(USize figureMaxSize);
	void Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix) override;

	std::shared_ptr<SingleFigure> NextFigure();

private:
	USize size_;
	std::shared_ptr<SingleFigure> nextFigure_;
};

#endif /* defined(__Tetris__NextController__) */
