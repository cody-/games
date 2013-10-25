//
//  SettingsPanel.mm
//  Tetris
//
//  Created by cody on 10/4/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./SettingsPanel.h"
#include "./TextLabel.h"

using namespace std;

namespace
{
	const GLKVector3 YELLOW = {0.94f, 0.92f, 0.71f};
}

///
SettingsPanel::SettingsPanel(CGSize size)
	: visible_(false)
	, borderPadding_(5)
	, lineHeight_(32)
	, fontName_("Courier-Bold")
	, fontSize_(22)
{
	contentSize_ = size;

	vBorder_ = make_shared<Border>(CGPoint{0, borderPadding_}, contentSize_.height - 2*borderPadding_, BorderType::VERTICAL);
	children_.push_back(vBorder_);
	hBorder_ = make_shared<Border>(CGPoint{borderPadding_, contentSize_.height}, contentSize_.width - 2*borderPadding_, BorderType::HORIZONTAL);
	children_.push_back(hBorder_);

	auto label = make_shared<TextLabel>("Restart game", fontName_, fontSize_, YELLOW);
	label->SetPosition({borderPadding_, contentSize_.height - lineHeight_});
	children_.push_back(label);
}

///
void SettingsPanel::Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix)
{
	if (!visible_)
		return;
	
	Node::Render(program, modelViewMatrix);
}

///
void SettingsPanel::Toggle()
{
	visible_ = !visible_;
}
