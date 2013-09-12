//
//  Figure.mm
//  Tetris
//
//  Created by cody on 9/11/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./Figure.h"
#include "./Square.h"
#include <vector>

using namespace std;

namespace
{
	const vector<vector<UPoint>> figures = {
		{{0, 1}, {1, 1}, {1, 0}, {2, 0}} // figure
	};
}

///
USize FigureSize(const vector<UPoint>& figure)
{
	UPoint border{0, 0};
	for (const auto& p : figure)
	{
		border.x = max(border.x, p.x);
		border.y = max(border.y, p.y);
	}

	return {border.x + 1U, border.y + 1U};
}

///
Figure::Figure(UPoint topCenter)
{
	const size_t f = 0; // Choose randomly
	for (UPoint p : figures[f])
		children_.push_back(unique_ptr<Node>(new Square(p)));

	USize size = FigureSize(figures[f]);
	SetSize(size);
	SetPosition({topCenter.x - size.w/2, topCenter.y - (size.h - 1)});
}

///
void Figure::SetPosition(UPoint position)
{
	Node::SetPosition(CGPointMake(position.x * Square::SIDE, position.y * Square::SIDE));
}

///
void Figure::SetSize(USize size)
{
	contentSize_ = CGSizeMake(size.w * Square::SIDE, size.h * Square::SIDE);
}
