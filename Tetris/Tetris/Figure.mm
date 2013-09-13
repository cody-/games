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

namespace
{
	const vector<Figure::BaseMatrix> figures = {
		{{1, 1, 0},
		 {0, 1, 1}},

		{{1, 1, 1},
		 {0, 0, 1}}
	};
}

///
constexpr USize FigureSize(const Figure::BaseMatrix& figure)
{
	return {figure[0].size(), figure.size()};
}

///
Figure::Figure(UPoint topCenter)
{
	const size_t f = 1; // TODO(cody): choose randomly
	SetBaseMatrix(figures[f]);
	SetGridPosition({topCenter.x - size_.w/2, topCenter.y - (size_.h - 1)});
}

///
inline void Figure::MoveTo(UPoint newPosition, PositionValidator validator)
{
	if (validator(newPosition))
		SetGridPosition(newPosition);
}

///
void Figure::MoveLeft(PositionValidator validator)
{
	MoveTo({gridPosition_.x - 1, gridPosition_.y}, validator);
}

///
void Figure::MoveRight(PositionValidator validator)
{
	MoveTo({gridPosition_.x + 1, gridPosition_.y}, validator);
}

///
void Figure::MoveDown(PositionValidator validator)
{
	MoveTo({gridPosition_.x, gridPosition_.y - 1}, validator);
}

///
void Figure::Rotate(PositionSizeValidator validator)
{
	BaseMatrix newBase(size_.w);
	for (size_t i = 0; i < size_.w; ++i)
	{
		newBase[i] = vector<bool>(size_.h);
		for (size_t j = 0; j < size_.h; ++j)
		{
			const size_t jOpposite = size_.h - 1 - j; // we don't want a "diagonal reflection", but rotation ("diagonal reflection" and then "vertical reflection")
			newBase[i][j] = baseMatrix_[jOpposite][i];
		}
	}

	const USize newSize = FigureSize(newBase);
	if (validator(gridPosition_, newSize))
		SetBaseMatrix(newBase, &newSize);
}

///
void Figure::SetBaseMatrix(BaseMatrix m, const USize* pSize)
{
	baseMatrix_ = move(m);
	SetGridSize(pSize ? *pSize : FigureSize(baseMatrix_));
	
	children_.clear();
	for (size_t i = 0; i < size_.w; ++i)
		for (size_t j = 0; j < size_.h; ++j)
			if (baseMatrix_[j][i])
			{
				const size_t jOpposite = size_.h - 1 - j; // iteration through matrix is top->down, while position increases down->top
				children_.push_back(shared_ptr<Node>(new Square({i, jOpposite})));
			}
}

///
void Figure::SetGridPosition(UPoint position)
{
	gridPosition_ = move(position);
	Node::SetPosition(CGPointMake(gridPosition_.x * Square::SIDE, gridPosition_.y * Square::SIDE));
}

///
void Figure::SetGridSize(USize size)
{
	size_ = move(size);
	contentSize_ = CGSizeMake(size_.w * Square::SIDE, size_.h * Square::SIDE);
}
