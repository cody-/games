//
//  Figure.h
//  Tetris
//
//  Created by cody on 9/11/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__Figure__
#define __Tetris__Figure__

#include "./Node.h"
#include "./Types.h"
#include "./FigureBaseMatrix.h"
#include <functional>
#include <vector>

///
class Figure
	: public Node
{
public:
	Figure(); // random figure
	Figure(GridPoint position, USize size); // zero constructor
	USize Size() const { return baseMatrix_.Size(); };
	GridPoint Position() const { return gridPosition_; }

	void SetPosition(GridPoint position);

	using PositionValidator = std::function<bool(const GridPoint&)>;
	using PositionSizeValidator = std::function<bool(const GridPoint&, const USize&)>;
	
	void MoveLeft(PositionValidator validator);
	void MoveRight(PositionValidator validator);
	void MoveDown(PositionValidator validator);
	void Rotate(PositionSizeValidator validator);

	bool CollidesWith(const Figure& rhs, const GridPoint& rhsPosition) const;
	void operator+=(const Figure& rhs); // Requirement rhs must be to the top right from the current figure

private:
	void SetBaseMatrix(FigureBaseMatrix m);
	void UpdateViewSize();
	void MoveTo(GridPoint newPosition, PositionValidator validator);

	GridPoint gridPosition_;
	FigureBaseMatrix baseMatrix_;
	const GLKVector3 color_;
};

#endif /* defined(__Tetris__Figure__) */
