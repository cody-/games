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
void CompositeFigure::operator+=(Figure& rhs)
{
	changedLines_.clear();

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
			newBase[relI][relJ] = newBase[relI][relJ] || rhs.baseMatrix_[i][j];
		}
	}

	for (auto& p : rhs.pieces_)
	{
		p->Move(relativePosition.x, relativePosition.y);
		pieces_.push_back(move(p));
	}

	baseMatrix_ = newBase;
	UpdateViewSize();
}

///
vector<int> CompositeFigure::FullLines() const
{
	vector<int> indexes;
	copy_if(begin(changedLines_), end(changedLines_), back_inserter(indexes), [&](int idx){
		return LineFull(idx);
	});

	return indexes;
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
unique_ptr<CompositeFigure> CompositeFigure::CutRows(int idx0, int idx1)
{
	auto slice = unique_ptr<CompositeFigure>(new CompositeFigure({Size().w, static_cast<unsigned>(idx1 - idx0)}));
	slice->SetPosition({0, idx0});
	for (size_t i = 0; i < slice->Size().w; ++i)
		for (size_t j = 0; j < slice->Size().h; ++j)
		{
			slice->baseMatrix_[i][j] = baseMatrix_[i][idx0 + j];
			baseMatrix_[i][idx0 + j] = 0;
		}

	// Partition pieces_: ours first, than those belong to slice
	auto sliceFirstPiece = partition(begin(pieces_), end(pieces_), [&](const unique_ptr<Square>& square) {
		return idx0 > square->Position().y || square->Position().y >= idx1;
	});

	// Move new pieces to slice
	for (auto p = sliceFirstPiece; p != end(pieces_); ++p)
	{
		(*p)->Move(0, -idx0);
		slice->pieces_.push_back(move(*p));
	}

	// Remove moved pieces
	pieces_.erase(sliceFirstPiece, end(pieces_));

	return slice;
}

///
unique_ptr<CompositeFigure> CompositeFigure::CutRows(int idx0)
{
	return CutRows(idx0, Size().h);
}

//
/////
//void CompositeFigure::RmLines(const vector<int>& indexes)
//{
//	if (indexes.size() == 0)
//		return;
//
//	USize newSize = {Size().w, Size().h - indexes.size()};
//	FigureBaseMatrix newBase(newSize);
//	for (size_t j = 0, j1 = 0; j < Size().h; ++j)
//		if (find(begin(indexes), end(indexes), j) == end(indexes))
//		{
//			for (size_t i = 0; i < Size().w; ++i)
//				newBase[i][j1] = baseMatrix_[i][j];
//			++j1;
//		}
//
//	SetBaseMatrix(newBase);
//}
