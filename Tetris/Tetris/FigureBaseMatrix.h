//
//  FigureBaseMatrix.h
//  Tetris
//
//  Created by cody on 9/14/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__FigureBaseMatrix__
#define __Tetris__FigureBaseMatrix__

#include <vector>
#include "./Types.h"

/// Binary matrix with buttom-up access
class FigureBaseMatrix
{
	using Column = std::vector<bool>;

public:
	FigureBaseMatrix();
	FigureBaseMatrix(const USize& size);
	FigureBaseMatrix(const std::vector<std::vector<bool>>& rows);
	Column& operator[](size_t i);
	const Column& operator[](size_t i) const;

	USize Size() const { return size_; }

	FigureBaseMatrix RotatedCCW() const;
	FigureBaseMatrix RotatedCW() const;
	FigureBaseMatrix Rotated(int times) const;

	void Print() const;

private:
	USize size_;
	std::vector<Column> columns_;
};

#endif /* defined(__Tetris__FigureBaseMatrix__) */
