//
//  SettingsPanel.h
//  Tetris
//
//  Created by cody on 10/4/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__SettingsPanel__
#define __Tetris__SettingsPanel__

#include "./Node.h"
#include "./Border.h"
#include <string>

///
class SettingsPanel
	: public Node
{
public:
	SettingsPanel(CGSize size);
	void Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix) override;
	void Toggle();

private:
	bool visible_;
	float borderPadding_;
	const unsigned short lineHeight_;
	const std::string fontName_;
	const unsigned fontSize_;
	
	std::shared_ptr<Border> vBorder_;
	std::shared_ptr<Border> hBorder_;
};

#endif /* defined(__Tetris__SettingsPanel__) */
