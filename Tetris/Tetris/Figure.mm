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
#include <random>

using namespace std;

namespace
{
	const vector<vector<vector<bool>>> figures = {
		{{1, 1, 0},
		 {0, 1, 1}},

		{{0, 1, 1},
		 {1, 1, 0}},

		{{1, 1, 1},
		 {0, 0, 1}},

		{{1, 1, 1},
		 {1, 0, 0}},

		{{1, 1},
		 {1, 1}},

		{{1, 1, 1},
		 {0, 1, 0}},

		{{1, 1, 1, 1}}
	};

//	const vector<GLKVector3> colors = {
//		{0.04, 0.27, 0.06}, // dark green
//		{0, 1, 0}, // green
//		{0, 0, 1}, // blue
//		{0, 1, 1}, // cyan
//		{1, 0, 1}, // ??
//		{1, 1, 0} // ??
//	};
}

///
template <class T>
T Random(const vector<T>& v)
{
	static random_device rd;
	static mt19937 gn(rd());
	static uniform_int_distribution<> dist(0, v.size() - 1);

	return v[dist(gn)];
}

///
Figure::Figure(GridPoint topCenter)
	: color_({1, 0, 0})
{
	SetBaseMatrix(Random(figures));
	SetGridPosition({topCenter.x - static_cast<int>(Size().w)/2, topCenter.y - (static_cast<int>(Size().h) - 1)});
}

///
Figure::Figure(GridPoint position, USize size)
	: color_({0.04, 0.27, 0.06})
{
	SetGridPosition(position);
	SetBaseMatrix(size);
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
	FigureBaseMatrix newBase({Size().h, Size().w});
	for (size_t i = 0; i < Size().w; ++i)
		for (size_t j = 0; j < Size().h; ++j)
			newBase[j][i] = baseMatrix_[i][newBase.Size().w - 1 - j];

	if (validator(gridPosition_, newBase.Size()))
		SetBaseMatrix(move(newBase));
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
				children_.push_back(shared_ptr<Node>(new Square({i, j}, color_)));
}

///
void Figure::SetGridPosition(GridPoint position)
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
bool Figure::CollidesWith(const Figure& rhs, const GridPoint& rhsPosition) const
{
	UPoint relativePosition = {static_cast<unsigned int>(rhsPosition.x - gridPosition_.x), static_cast<unsigned int>(rhsPosition.y - gridPosition_.y)};
	if (relativePosition.x >= Size().w || relativePosition.y >= Size().h)
		return false;

	for (size_t i = 0; i < rhs.Size().w; ++i)
		for (size_t j = 0; j < rhs.Size().h; ++j)
			if (rhs.baseMatrix_[i][j])
			{
				size_t relI = relativePosition.x + i;
				size_t relJ = relativePosition.y + j;
				if (relI < Size().w && relJ < Size().h && baseMatrix_[relI][relJ])
					return true;
			}
			
	return false;
}

///
void Figure::operator+=(const Figure& rhs)
{
	UPoint relativePosition = {static_cast<unsigned int>(rhs.gridPosition_.x - gridPosition_.x), static_cast<unsigned int>(rhs.gridPosition_.y - gridPosition_.y)};
	USize newSize = {max(relativePosition.x + rhs.Size().w, Size().w), max(relativePosition.y + rhs.Size().h, Size().h)};
	FigureBaseMatrix newBase(newSize);
	for (size_t i = 0; i < Size().w; ++i)
		for (size_t j = 0; j < Size().h; ++j)
			newBase[i][j] = baseMatrix_[i][j];

	for (size_t i = 0; i < rhs.Size().w; ++i)
		for (size_t j = 0; j < rhs.Size().h; ++j)
		{
			size_t relI = relativePosition.x + i;
			size_t relJ = relativePosition.y + j;
			newBase[relI][relJ] = rhs.baseMatrix_[i][j];
			if (newBase[relI][relJ])
			{
				children_.push_back(shared_ptr<Node>(new Square({relI, relJ}, color_)));
			}
		}

	baseMatrix_ = newBase;
	UpdateViewSize();
}
