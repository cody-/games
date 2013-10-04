//
//  GameField.h
//  Tetris
//
//  Created by cody on 9/10/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__GameField__
#define __Tetris__GameField__

#include "./TexturedNode.h"
#include "./SingleFigure.h"
#include "./FigureStack.h"
#include <memory>
#include <functional>

///
class GameField
	: public TexturedNode
{
public:
	static unsigned int Width();

	GameField(CGFloat height, std::function<std::shared_ptr<SingleFigure>()> figureGenerator);
	void Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix) override;

	void MoveLeft();
	void MoveRight();
	void MoveDown();
	void Rotate();

	void NewFigure();
	void DropFigure();

	void SetTouchdownCallback(std::function<void()> cb) { touchdownCallback_ = cb; }
	void SetLinesCallback(std::function<void(unsigned)> cb) { linesCallback_ = cb; }

private:
	bool ValidateMove(const GridPoint& newPosition) const;
	bool ValidateMoveDown(const GridPoint& newPosition) const;
	bool ValidateRotation(const GridPoint& newPosition, const USize& newSize) const;

	static const unsigned short RIGHT = 12;
	const unsigned short TOP;

	std::function<std::shared_ptr<SingleFigure>()> figureGenerator_;
	std::function<void()> touchdownCallback_;
	std::function<void(unsigned)> linesCallback_;
	std::shared_ptr<SingleFigure> activeFigure_;
	std::shared_ptr<FigureStack> figureStack_;
};

#endif /* defined(__Tetris__GameField__) */
