//
//  TexturedQuad.mm
//  Tetris
//
//  Created by cody on 9/11/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./TexturedQuad.h"

///
TexturedQuad::TexturedQuad(CGSize size)
	: bl({{0, 0}, {0, 0}})
	, br({{size.width, 0}, {1, 0}})
	, tl({{0, size.height}, {0, 1}})
	, tr({{size.width, size.height}, {1, 1}})
{
}
