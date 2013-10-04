//
//  Button.h
//  Tetris
//
//  Created by cody on 9/12/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__Button__
#define __Tetris__Button__

#include "./TexturedNode.h"
#include <functional>

enum class Btn
{
	LEFT,
	RIGHT,
	DOWN,
	ROTATE,
	SETTINGS
};

///
class Button
	: public TexturedNode
{
public:
	Button(const std::string& img, CGFloat radius, CGPoint position, std::function<void()> action);
	void Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix) override;
	bool HandleTap(const CGPoint& point) override;

private:
	std::function<void()> action_;
};

#endif /* defined(__Tetris__Button__) */
