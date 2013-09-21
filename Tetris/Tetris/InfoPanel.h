//
//  InfoPanel.h
//  Tetris
//
//  Created by cody on 9/21/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__InfoPanel__
#define __Tetris__InfoPanel__

#include "./Node.h"
#include "./TextLabel.h"
#include "./NumberLabel.h"

///
class InfoPanel
	: public Node
{
public:
	InfoPanel();

	void Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix) override;
	void UpdateLines(int diff);

private:
	std::shared_ptr<NumberLabel> AddPanel(unsigned position, std::string labelText, unsigned initialVal);
	GLKVector3 textColor_;

	const unsigned short lineHeight_;
	const unsigned short labelWidth_;
	const std::string fontName_;
	const unsigned fontSize_;

	std::shared_ptr<NumberLabel> level_;
	std::shared_ptr<NumberLabel> speed_;
	std::shared_ptr<NumberLabel> lines_;
	std::shared_ptr<NumberLabel> score_;
};

#endif /* defined(__Tetris__InfoPanel__) */
