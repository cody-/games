//
//  SettingsPanel.mm
//  Tetris
//
//  Created by cody on 10/4/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "SettingsPanel.h"

using namespace std;

///
SettingsPanel::SettingsPanel(CGSize size)
{
	contentSize_ = size;

	vBorder_ = make_shared<Border>(CGPoint{0, 5}, contentSize_.height - 10, BorderType::VERTICAL);
	children_.push_back(vBorder_);
	hBorder_ = make_shared<Border>(CGPoint{5, contentSize_.height}, contentSize_.width - 10, BorderType::HORIZONTAL);
	children_.push_back(hBorder_);
}

///
void SettingsPanel::Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix)
{
	Node::Render(program, modelViewMatrix);
}
