//
//  FigureStack.h
//  Tetris
//
//  Created by cody on 9/20/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__FigureStack__
#define __Tetris__FigureStack__

#include "./Node.h"
#include "./CompositeFigure.h"

#include <list>

///
class FigureStack
	: public Node
{
public:
	FigureStack(unsigned int width);
	void Push(Figure& figure);
	bool CollidesWith(const Figure& figure, const GridPoint& figurePosition) const;
	unsigned RmFullLines();

	void Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix) override;

private:
	CompositeFigure& Top();
	const CompositeFigure& Top() const;
	std::unique_ptr<CompositeFigure> PopBack();
	std::unique_ptr<CompositeFigure> PopFront();
	
	
	std::list<std::unique_ptr<CompositeFigure>> figures_;
};

#endif /* defined(__Tetris__FigureStack__) */
