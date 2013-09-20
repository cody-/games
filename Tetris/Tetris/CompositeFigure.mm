//
//  CompositeFigure.mm
//  Tetris
//
//  Created by cody on 9/20/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./CompositeFigure.h"
#include "./Square.h"

using namespace std;

namespace
{
	const GLKVector3 DARK_GREEN = {0.04, 0.27, 0.06};
}

///
CompositeFigure::CompositeFigure(USize size)
	: Figure(FigureBaseMatrix(size), DARK_GREEN)
{
}

///
bool CompositeFigure::CollidesWith(const Figure& rhs, const GridPoint& rhsPosition) const
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
void CompositeFigure::operator+=(const Figure& rhs)
{
	UPoint relativePosition = {static_cast<unsigned int>(rhs.gridPosition_.x - gridPosition_.x), static_cast<unsigned int>(rhs.gridPosition_.y - gridPosition_.y)};
	USize newSize = {max(relativePosition.x + rhs.Size().w, Size().w), max(relativePosition.y + rhs.Size().h, Size().h)};
	FigureBaseMatrix newBase(newSize);
	for (size_t i = 0; i < Size().w; ++i)
		for (size_t j = 0; j < Size().h; ++j)
			newBase[i][j] = baseMatrix_[i][j];

	for (size_t j = 0; j < rhs.Size().h; ++j)
	{
		size_t relJ = relativePosition.y + j;
		changedLines_.push_back(relJ);
		for (size_t i = 0; i < rhs.Size().w; ++i)
		{
			size_t relI = relativePosition.x + i;
			if (rhs.baseMatrix_[i][j])
			{
				newBase[relI][relJ] = rhs.baseMatrix_[i][j];
				children_.push_back(shared_ptr<Node>(new Square({relI, relJ}, rhs.color_)));
			}
		}
	}

	baseMatrix_ = newBase;
	UpdateViewSize();
}

///
unsigned CompositeFigure::RmFullLines()
{
	vector<int> indexes;
	for (auto idx : changedLines_)
		if (LineFull(idx))
			indexes.push_back(idx);

	RmLines(indexes);
	changedLines_.clear();
	return indexes.size();
}

///
bool CompositeFigure::LineFull(int idx) const
{
	for (size_t i = 0; i < Size().w; ++i)
		if (!baseMatrix_[i][idx])
			return false;

	return true;
}

///
void CompositeFigure::RmLines(const vector<int>& indexes)
{
	if (indexes.size() == 0)
		return;

	USize newSize = {Size().w, Size().h - indexes.size()};
	FigureBaseMatrix newBase(newSize);
	for (size_t j = 0, j1 = 0; j < Size().h; ++j)
		if (find(begin(indexes), end(indexes), j) == end(indexes))
		{
			for (size_t i = 0; i < Size().w; ++i)
				newBase[i][j1] = baseMatrix_[i][j];
			++j1;
		}

	SetBaseMatrix(newBase);
}
