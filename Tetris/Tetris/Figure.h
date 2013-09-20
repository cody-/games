//
//  Figure.h
//  Tetris
//
//  Created by cody on 9/11/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__Figure__
#define __Tetris__Figure__

#include "./Node.h"
#include "./Types.h"
#include "./FigureBaseMatrix.h"
#include <functional>
#include <vector>

///
class Figure
	: public Node
{
public:
	Figure(FigureBaseMatrix baseMatrix, GLKVector3 color);
	USize Size() const { return baseMatrix_.Size(); };
	GridPoint Position() const { return gridPosition_; }

	void SetPosition(GridPoint position);

protected:
	void SetBaseMatrix(FigureBaseMatrix m);
	void UpdateViewSize();

	FigureBaseMatrix baseMatrix_;
	const GLKVector3 color_;
	GridPoint gridPosition_;

	friend class CompositeFigure;
};

#endif /* defined(__Tetris__Figure__) */
