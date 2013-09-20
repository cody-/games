//
//  FigureStack.mm
//  Tetris
//
//  Created by cody on 9/20/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "FigureStack.h"
#include <iostream>

using namespace std;

///
FigureStack::FigureStack(unsigned int width)
{
	auto base = unique_ptr<CompositeFigure>(new CompositeFigure({width, 1U}));
	base->SetPosition({0, 0});
	figures_.push_back(move(base));
}

///
void FigureStack::Push(Figure& figure)
{
	Top() += figure;
}

///
bool FigureStack::CollidesWith(const Figure& figure, const GridPoint& figurePosition) const
{
	return Top().CollidesWith(figure, figurePosition);
}

///
unsigned FigureStack::RmFullLines()
{
	vector<int> lineIndexes = Top().FullLines();
	if (lineIndexes.size() == 0)
		return 0;

	// Split top figure to 
	auto top = PopBack();
	int pos = 0;
	for (auto idx : lineIndexes)
	{
		if (idx > pos)
			figures_.push_back(top->CutRows(pos, idx));

		// TODO(cody): disappear effect, probably set callback to join figures after
		//figures_.push_back(top->CutRows(idx, idx + 1));
		pos = idx + 1;
	}
	if (pos < top->Size().h)
		figures_.push_back(top->CutRows(pos));

	// Move all figures down on top of each other
	pos = 0;
	for (auto& f : figures_)
	{
		f->SetPosition({0, pos});
		pos = f->Size().h;
	}

	// Join all figures to one
	auto bottom = PopFront();
	while (figures_.size() > 0)
		*bottom += *PopFront();
	figures_.push_back(move(bottom));

	return lineIndexes.size();
}

///
void FigureStack::Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix)
{
	GLKMatrix4 childModelViewMatrix = GLKMatrix4Multiply(modelViewMatrix, ModelMatrix());
	for_each(begin(figures_), end(figures_), [&](const unique_ptr<CompositeFigure>& figure) {
		figure->Render(program, childModelViewMatrix);
	});
}

///
CompositeFigure& FigureStack::Top()
{
	return *figures_.back();
}

///
const CompositeFigure& FigureStack::Top() const
{
	return const_cast<FigureStack*>(this)->Top();
}

///
unique_ptr<CompositeFigure> FigureStack::PopBack()
{
	auto top = move(figures_.back());
	figures_.pop_back();
	return top;
}

///
unique_ptr<CompositeFigure> FigureStack::PopFront()
{
	auto bottom = move(figures_.front());
	figures_.pop_front();
	return bottom;
}

