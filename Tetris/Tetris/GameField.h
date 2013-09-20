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
#include "./CompositeFigure.h"
#include <memory>
#include <vector>
#include <functional>
#include <mutex>

///
class GameField
	: public TexturedNode
{
public:
	static unsigned int Width();

	GameField(CGFloat height, std::function<std::shared_ptr<SingleFigure>()> figureGenerator);
	void Update(float dt) override;
	void Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix) override;

	void MoveLeft();
	void MoveRight();
	void MoveDown();
	void Rotate();

	void SetTouchdownCallback(std::function<void()> cb);

private:
	void NewFigure();
	void DropFigure();
	bool ValidateMove(const GridPoint& newPosition) const;
	bool ValidateMoveDown(const GridPoint& newPosition) const;
	bool ValidateRotation(const GridPoint& newPosition, const USize& newSize) const;

	static const unsigned short RIGHT = 12;
	const unsigned short TOP;

	std::function<std::shared_ptr<SingleFigure>()> figureGenerator_;
	std::function<void()> touchdownCallback_;
	std::shared_ptr<SingleFigure> activeFigure_;
	std::shared_ptr<CompositeFigure> blocks_;

	std::vector<std::function<void()>> actions_;
	std::mutex actionsAccess_;
	mutable bool touchdown_;
};

#endif /* defined(__Tetris__GameField__) */
