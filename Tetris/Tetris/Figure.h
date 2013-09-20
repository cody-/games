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
#include "./Square.h"
#include <vector>

///
class Figure
	: public Node
{
public:
	Figure(FigureBaseMatrix baseMatrix, GLKVector3 color);
	USize Size() const { return baseMatrix_.Size(); };
	GridPoint Position() const { return gridPosition_; }

	void Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix) override;

	void SetPosition(GridPoint position);
	void Print() const { baseMatrix_.Print(); }

protected:
	void SetBaseMatrix(FigureBaseMatrix m);
	void UpdateViewSize();

	FigureBaseMatrix baseMatrix_;
	const GLKVector3 color_;
	GridPoint gridPosition_;
	std::vector<std::unique_ptr<Square>> pieces_;

	friend class CompositeFigure;
};

#endif /* defined(__Tetris__Figure__) */
