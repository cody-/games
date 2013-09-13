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
#include "./Figure.h"
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

	GameField(CGPoint position, CGFloat height);
	void Update(float dt) override;
	void Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix) override;

	void MoveLeft();
	void MoveRight();
	void MoveDown();
	void Rotate();

private:
	void NewFigure();
	bool ValidateMove(const UPoint& newPosition) const;
	bool ValidateRotation(const UPoint& newPosition, const USize& newSize) const;

	static const unsigned short RIGHT = 12;
	const unsigned short TOP;
	std::shared_ptr<Figure> activeFigure_;

	std::vector<std::function<void()>> actions_;
	std::mutex actionsAccess_;
};

#endif /* defined(__Tetris__GameField__) */
