//
//  GameField.mm
//  Tetris
//
//  Created by cody on 9/10/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "GameField.h"
#include "./Border.h"
#include "./Figure.h"
#include "./Square.h"

using namespace std;

///
unsigned int GameField::Width()
{
	return (RIGHT + 1) * Square::SIDE + 2 * Border::WIDTH;
}

///
GameField::GameField(CGPoint position, CGFloat height)
	: TexturedNode("black-square32.png", {static_cast<CGFloat>(Width() - 1), height}, TextureMode::REPEAT)
	, TOP(height/Square::SIDE - 1)
{
	position_ = {position.x + Border::WIDTH, position.y};

	auto lBorder = new Border({-Border::WIDTH, 0}, contentSize_.height);
	children_.push_back(unique_ptr<Node>(lBorder));
	auto rBorder = new Border({contentSize_.width, 0}, contentSize_.height);
	children_.push_back(unique_ptr<Node>(rBorder));

	NewFigure();
}

///
void GameField::NewFigure()
{
	auto figure = new Figure({RIGHT/2, TOP});
	children_.push_back(std::unique_ptr<Node>(figure));
}

///
void GameField::Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix)
{
	glUniform1i(program.uniforms.useColor, 1);
	glUniform4f(program.uniforms.color, 1.0, 1.0, 1.0, 0.25);

	TexturedNode::Render(program, modelViewMatrix);
}
