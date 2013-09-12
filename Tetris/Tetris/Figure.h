//
//  Figure.h
//  Tetris
//
//  Created by cody on 9/11/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__Figure__
#define __Tetris__Figure__

#include "./Node.h"
#include "./Types.h"

///
class Figure
	: public Node
{
public:
	Figure(UPoint topCenter);

private:
	void SetPosition(UPoint position);
	void SetSize(USize size);
};

#endif /* defined(__Tetris__Figure__) */
