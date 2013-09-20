//
//  SingleFigure.mm
//  Tetris
//
//  Created by cody on 9/20/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "SingleFigure.h"
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
SingleFigure::SingleFigure()
	: Figure(FigureBaseMatrix(Random(figures)).Rotated(Random(0, 3)), RandomColor())
{
}

///
inline void SingleFigure::MoveTo(GridPoint newPosition, PositionValidator validator)
{
	if (validator(newPosition))
		SetPosition(newPosition);
}

///
void SingleFigure::MoveLeft(PositionValidator validator)
{
	MoveTo({gridPosition_.x - 1, gridPosition_.y}, validator);
}

///
void SingleFigure::MoveRight(PositionValidator validator)
{
	MoveTo({gridPosition_.x + 1, gridPosition_.y}, validator);
}

///
void SingleFigure::MoveDown(PositionValidator validator)
{
	MoveTo({gridPosition_.x, gridPosition_.y - 1}, validator);
}

///
void SingleFigure::Rotate(PositionSizeValidator validator)
{
	FigureBaseMatrix newBase = baseMatrix_.Rotated(-1);
	if (validator(gridPosition_, newBase.Size()))
		SetBaseMatrix(move(newBase));
}

