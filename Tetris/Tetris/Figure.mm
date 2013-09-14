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

		{{0, 1, 1},
		 {1, 1, 0}},

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
Figure::Figure(GridPoint topCenter)
{
	const size_t f = 0; // TODO(cody): choose randomly
	SetBaseMatrix(figures[f]);
	SetGridPosition({topCenter.x - static_cast<int>(size_.w)/2, topCenter.y - (static_cast<int>(size_.h) - 1)});
}

///
Figure::Figure(GridPoint position, USize size)
{
	SetGridPosition(position);
	SetBaseMatrix(Figure::BaseMatrix(size.h, vector<bool>(size.w, false)));
}

///
inline void Figure::MoveTo(GridPoint newPosition, PositionValidator validator)
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
void Figure::SetGridPosition(GridPoint position)
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

///
bool Figure::CollidesWith(const Figure& rhs, const GridPoint& rhsPosition) const
{
	UPoint relativePosition = {static_cast<unsigned int>(rhsPosition.x - gridPosition_.x), static_cast<unsigned int>(rhsPosition.y - gridPosition_.y)};
	if (relativePosition.x >= size_.w || relativePosition.y >= size_.h)
		return false;

	for (size_t i = 0; i < rhs.size_.w; ++i)
		for (size_t j = 0; j < rhs.size_.h; ++j)
			if (rhs.baseMatrix_[j][i])
			{
				size_t relI = relativePosition.x + i;
				size_t relJ = relativePosition.y + j;
				if (relI < size_.w && relJ < size_.h && baseMatrix_[relJ][relI])
					return true;
			}
			
	return false;
}

///
void Figure::operator+=(const Figure& rhs)
{
	UPoint relativePosition = {static_cast<unsigned int>(rhs.gridPosition_.x - gridPosition_.x), static_cast<unsigned int>(rhs.gridPosition_.y - gridPosition_.y)};
	USize newSize = {max(relativePosition.x + rhs.size_.w, size_.w), max(relativePosition.y + rhs.size_.h, size_.h)};
	Figure::BaseMatrix newBase(newSize.h, vector<bool>(newSize.w, false));
	for (size_t i = 0; i < size_.w; ++i)
		for (size_t j = 0; j < size_.h; ++j)
			newBase[newSize.h - size_.h + j][i] = baseMatrix_[j][i];

	for (size_t i = 0; i < rhs.size_.w; ++i)
		for (size_t j = 0; j < rhs.size_.h; ++j)
		{
			size_t newI = relativePosition.x + i;
			newBase[j][newI] = rhs.baseMatrix_[j][i];
			if (newBase[j][newI])
			{
				const size_t jOpposite = newSize.h - 1 - j; // iteration through matrix is top->down, while position increases down->top
				children_.push_back(shared_ptr<Node>(new Square({newI, jOpposite})));
			}
		}

	baseMatrix_ = newBase;
	SetGridSize(newSize);
}
