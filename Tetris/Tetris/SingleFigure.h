//
//  SingleFigure.h
//  Tetris
//
//  Created by cody on 9/20/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__SingleFigure__
#define __Tetris__SingleFigure__

#include "./Figure.h"

/// Random figure
class SingleFigure
	: public Figure
{
public:
	SingleFigure();

	using PositionValidator = std::function<bool(const GridPoint&)>;
	using PositionSizeValidator = std::function<bool(const GridPoint&, const USize&)>;
	
	void MoveLeft(PositionValidator validator);
	void MoveRight(PositionValidator validator);
	void MoveDown(PositionValidator validator);
	void Rotate(PositionSizeValidator validator);

private:
	void MoveTo(GridPoint newPosition, PositionValidator validator);
};

#endif /* defined(__Tetris__SingleFigure__) */
