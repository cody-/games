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

	const GLKVector3 RED = {1, 0, 0};
	const GLKVector3 DARK_GREEN = {0.04, 0.27, 0.06};
}

///
int Random(int x0, int x1)
{
	static random_device rd;
	static mt19937 gn(rd());
	uniform_int_distribution<> dist(x0, x1);

	return dist(gn);
}

///
template <class T>
inline T Random(const vector<T>& v)
{
	return v[Random(0, v.size() - 1)];
}

///
GLKVector3 RandomColor()
{
	int r = Random(0, 255);
	int g = Random(0, 255);
	int b = Random(0, 255);
	return {r/256.0f, g/256.0f, b/256.0f};
}

///
Figure::Figure()
	: color_(RandomColor())
{
	SetBaseMatrix(FigureBaseMatrix(Random(figures)).Rotated(Random(0, 3)));
}

///
Figure::Figure(GridPoint position, USize size)
	: color_(DARK_GREEN)
{
	SetPosition(position);
	SetBaseMatrix(size);
}

///
inline void Figure::MoveTo(GridPoint newPosition, PositionValidator validator)
{
	if (validator(newPosition))
		SetPosition(newPosition);
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
	FigureBaseMatrix newBase = baseMatrix_.Rotated(-1);
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
				children_.push_back(shared_ptr<Node>(new Square({relI, relJ}, rhs.color_)));
			}
		}

	baseMatrix_ = newBase;
	UpdateViewSize();
}
