//
//  FigureBaseMatrix.mm
//  Tetris
//
//  Created by cody on 9/14/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./FigureBaseMatrix.h"

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
