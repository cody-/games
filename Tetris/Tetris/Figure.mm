//
//  Figure.mm
//  Tetris
//
//  Created by cody on 9/11/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./Figure.h"
#include "./Square.h"
#include <vector>

using namespace std;

///
Figure::Figure(FigureBaseMatrix baseMatrix, GLKVector3 color)
	: color_(color)
{
	SetBaseMatrix(baseMatrix);
}

///
void Figure::SetBaseMatrix(FigureBaseMatrix m)
{
	baseMatrix_ = move(m);
	UpdateViewSize();
	
	children_.clear();
	for (size_t i = 0; i < Size().w; ++i)
		for (size_t j = 0; j < Size().h; ++j)
			if (baseMatrix_[i][j])
				pieces_.push_back(unique_ptr<Square>(new Square({i, j}, color_)));
}

///
void Figure::SetPosition(GridPoint position)
{
	gridPosition_ = move(position);
	Node::SetPosition(CGPointMake(gridPosition_.x * Square::SIDE, gridPosition_.y * Square::SIDE));
}

///
void Figure::UpdateViewSize()
{
	contentSize_ = CGSizeMake(Size().w * Square::SIDE, Size().h * Square::SIDE);
}

///
void Figure::Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix)
{
	GLKMatrix4 childModelViewMatrix = GLKMatrix4Multiply(modelViewMatrix, ModelMatrix());
	for_each(pieces_.begin(), pieces_.end(), [&](const unique_ptr<Square>& piece) {
		piece->Render(program, childModelViewMatrix);
	});
}
