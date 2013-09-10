//
//  Scene.h
//  Tetris
//
//  Created by cody on 9/9/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__Scene__
#define __Tetris__Scene__

#import "./Node.h"

///
class Scene
	: public Node
{
public:
	Scene(const CGSize& size, const ShaderProgram& program);
};

#endif /* defined(__Tetris__Scene__) */