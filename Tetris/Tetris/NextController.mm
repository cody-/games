//
//  NextController.mm
//  Tetris
//
//  Created by cody on 9/19/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./NextController.h"
#include "./Square.h"

using namespace std;

///
NextController::NextController(USize figureMaxSize)
	: TexturedNode("black-square32.png", {static_cast<CGFloat>(figureMaxSize.w * Square::SIDE), static_cast<CGFloat>(figureMaxSize.h * Square::SIDE)}, TextureMode::REPEAT)
	, size_(figureMaxSize)
{
	NextFigure();
}

///
void NextController::Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix)
{
	glUniform1i(program.uniforms.useColor, 1);
	glUniform4f(program.uniforms.color, 1.0, 1.0, 1.0, 0.25);

	TexturedNode::Render(program, modelViewMatrix);
}

///
shared_ptr<Figure> NextController::NextFigure()
{
	auto nextFigure = nextFigure_;

	nextFigure_ = make_shared<Figure>();
	nextFigure_->SetPosition({0, 0});
	children_.clear();
	children_.push_back(nextFigure_);
	
	return nextFigure;
}
