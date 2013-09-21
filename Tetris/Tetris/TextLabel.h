//
//  TextLabel.h
//  Tetris
//
//  Created by cody on 9/21/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__TextLabel__
#define __Tetris__TextLabel__

#include "./TexturedNode.h"

///
class TextLabel
	: public TexturedNode
{
public:
	TextLabel(std::string label, std::string fontName, unsigned fontSize);
};

#endif /* defined(__Tetris__TextLabel__) */
