//
//  FigureStack.mm
//  Tetris
//
//  Created by cody on 9/20/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "FigureStack.h"

using namespace std;

///
FigureStack::FigureStack(unsigned int width)
{
	auto base = make_shared<CompositeFigure>(USize{width, 1U});
	base->SetPosition({0, 0});
	figures_.push_back(base);
	children_.push_back(base);
}

///
void FigureStack::Push(Figure& figure)
{
	*figures_.back() += figure;
	// RmFullLines();
}

///
bool FigureStack::CollidesWith(const Figure& figure, const GridPoint& figurePosition) const
{
	return figures_.back()->CollidesWith(figure, figurePosition);
}
