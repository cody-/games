//
//  GameField.mm
//  Tetris
//
//  Created by cody on 9/10/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "GameField.h"
#include "./Border.h"
#include "Square.h"

using namespace std;

///
unsigned int GameField::Width()
{
	return (RIGHT + 1) * Square::SIDE + 2 * Border::WIDTH;
}

///
GameField::GameField(CGPoint position, CGFloat height)
	: TOP(height/Square::SIDE - 1)
{
	position_ = {position.x + Border::WIDTH, position.y};
	contentSize_ = {static_cast<CGFloat>(Width() - 1), height};

	auto lBorder = new Border({-Border::WIDTH, 0}, contentSize_.height);
	children_.push_back(unique_ptr<Node>(lBorder));
	auto rBorder = new Border({contentSize_.width, 0}, contentSize_.height);
	children_.push_back(unique_ptr<Node>(rBorder));

	auto figure = new Square();
	figure->SetPosition({RIGHT, TOP});

	children_.push_back(std::unique_ptr<Node>(figure));

	auto figure2 = new Square();
	figure2->SetPosition({0, 0});
	children_.push_back(unique_ptr<Node>(figure2));
}
