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
	Figure(UPoint topCenter);
	USize Size() const { return size_; };

	using PositionValidator = std::function<bool(const UPoint&)>;
	using PositionSizeValidator = std::function<bool(const UPoint&, const USize&)>;
	using BaseMatrix = std::vector<std::vector<bool>>;
	
	void MoveLeft(PositionValidator validator);
	void MoveRight(PositionValidator validator);
	void MoveDown(PositionValidator validator);
	void Rotate(PositionSizeValidator validator);

private:
	void SetBaseMatrix(BaseMatrix m, const USize* pSize = nullptr);
	void SetGridPosition(UPoint position);
	void SetGridSize(USize size);
	void MoveTo(UPoint newPosition, PositionValidator validator);

	UPoint gridPosition_;
	USize size_;
	BaseMatrix baseMatrix_;
};

#endif /* defined(__Tetris__Figure__) */
