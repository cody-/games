//
//  InfoPanel.mm
//  Tetris
//
//  Created by cody on 9/21/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./InfoPanel.h"
#include "./Square.h"

using namespace std;

namespace
{
	const GLKVector3 YELLOW = {0.94f, 0.92f, 0.71f};
}

///
InfoPanel::InfoPanel()
	: lineHeight_(Square::SIDE)
	, labelWidth_(100)
	, fontName_("Courier-Bold")
	, fontSize_(25)
	, textColor_(YELLOW)
{
	contentSize_ = {0, 0};
	score_ = AddPanel(0, "Score", 0);
	lines_ = AddPanel(1, "Lines", 0);
	speed_ = AddPanel(2, "Speed", 1);
	level_ = AddPanel(3, "Level", 0);
}

///
void InfoPanel::Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix)
{
	glUniform1i(program.uniforms.useColor, 1);
	glUniform4f(program.uniforms.color, textColor_.r, textColor_.g, textColor_.b, 1.0);

	Node::Render(program, modelViewMatrix);
}

///
shared_ptr<NumberLabel> InfoPanel::AddPanel(unsigned position, string labelText, unsigned initialVal)
{
	const float offsetY = position * lineHeight_;

	auto label = make_shared<TextLabel>(labelText + ":", fontName_, fontSize_);
	label->SetPosition({0, offsetY});
	children_.push_back(label);

	auto val = make_shared<NumberLabel>(initialVal, fontName_, fontSize_);
	val->SetPosition({static_cast<CGFloat>(labelWidth_), offsetY});
	children_.push_back(val);

	contentSize_ = {max(contentSize_.width, labelWidth_ + val->ContentSize().width), contentSize_.height + lineHeight_};

	return val;
}

///
void InfoPanel::SetLines(unsigned val)
{
	lines_->SetVal(val);
}

///
void InfoPanel::SetSpeed(unsigned val)
{
	speed_->SetVal(val);
}
