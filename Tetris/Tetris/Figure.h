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
#include <functional>
#include <vector>

///
class Figure
	: public Node
{
public:
	Figure(GridPoint topCenter);
	Figure(GridPoint position, USize size); // zero constructor
	USize Size() const { return size_; };
	GridPoint Position() const { return gridPosition_; }

	using PositionValidator = std::function<bool(const GridPoint&)>;
	using PositionSizeValidator = std::function<bool(const GridPoint&, const USize&)>;
	using BaseMatrix = std::vector<std::vector<bool>>;
	
	void MoveLeft(PositionValidator validator);
	void MoveRight(PositionValidator validator);
	void MoveDown(PositionValidator validator);
	void Rotate(PositionSizeValidator validator);

	bool CollidesWith(const Figure& rhs, const GridPoint& rhsPosition) const;
	void operator+=(const Figure& rhs); // Requirement rhs must be to the top right from the current figure

private:
	void SetBaseMatrix(BaseMatrix m, const USize* pSize = nullptr);
	void SetGridPosition(GridPoint position);
	void SetGridSize(USize size);
	void MoveTo(GridPoint newPosition, PositionValidator validator);

	GridPoint gridPosition_;
	USize size_;
	BaseMatrix baseMatrix_;
};

#endif /* defined(__Tetris__Figure__) */
