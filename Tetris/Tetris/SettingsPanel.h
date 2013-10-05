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

///
class SettingsPanel
	: public Node
{
public:
	SettingsPanel(CGSize size);
	void Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix) override;

private:
	std::shared_ptr<Border> vBorder_;
	std::shared_ptr<Border> hBorder_;
};

#endif /* defined(__Tetris__SettingsPanel__) */
