//
//  FigureBaseMatrix.mm
//  Tetris
//
//  Created by cody on 9/14/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./FigureBaseMatrix.h"
#include <iostream>

using namespace std;

///
FigureBaseMatrix::FigureBaseMatrix()
	: FigureBaseMatrix({0U, 0U})
{
}

///
FigureBaseMatrix::FigureBaseMatrix(const USize& size)
	: size_(size)
	, columns_(size.w, Column(size.h, false))
{
}

///
FigureBaseMatrix::FigureBaseMatrix(const vector<vector<bool>>& rows)
	: FigureBaseMatrix({rows[0].size(), rows.size()})
{
	for (size_t i = 0; i < size_.w; ++i)
		for (size_t j = 0; j < size_.h; ++j)
			columns_[i][j] = rows[size_.h - 1 - j][i];
}

///
FigureBaseMatrix::Column& FigureBaseMatrix::operator[](size_t i)
{
	return columns_[i];
}

///
const FigureBaseMatrix::Column& FigureBaseMatrix::operator[](size_t i) const
{
	return columns_[i];
}

///
FigureBaseMatrix FigureBaseMatrix::RotatedCCW() const
{
	FigureBaseMatrix rotated({size_.h, size_.w});
	for (size_t i = 0; i < size_.w; ++i)
		for (size_t j = 0; j < size_.h; ++j)
			rotated[j][i] = (*this)[i][rotated.size_.w - 1 - j];

	return rotated;
}

///
FigureBaseMatrix FigureBaseMatrix::RotatedCW() const
{
	return FigureBaseMatrix(columns_);
}

///
FigureBaseMatrix FigureBaseMatrix::Rotated(int times) const
{
	switch (times % 4)
	{
	case 0:
		return *this;
	case -1: case 3:
		return RotatedCCW();
	case 1: case -3:
		return RotatedCW();
	case 2: case -2:
		return RotatedCW().RotatedCW();
	default:
		break;
	}

	throw "o.O";
}

///
void FigureBaseMatrix::Print() const
{
	for (size_t j = 0; j < Size().h; ++j)
	{
		for (size_t i = 0; i < Size().w; ++i)
			cout << " " << (*this)[i][Size().h - 1 - j];
		cout << endl;
	}
}
