//
//  CompositeFigure.h
//  Tetris
//
//  Created by cody on 9/20/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__CompositeFigure__
#define __Tetris__CompositeFigure__

#include "./Figure.h"

///
class CompositeFigure
	: public Figure
{
public:
	CompositeFigure(USize size);

	bool CollidesWith(const Figure& rhs, const GridPoint& rhsPosition) const;
	void operator+=(const Figure& rhs); // Requirement rhs must be to the top right from the current figure

	unsigned RmFullLines();

private:
	bool LineFull(int idx) const;
	void RmLines(const std::vector<int>& indexes);
	
	std::vector<int> changedLines_;
};

#endif /* defined(__Tetris__CompositeFigure__) */
