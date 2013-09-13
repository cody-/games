//
//  Scene.h
//  Tetris
//
//  Created by cody on 9/9/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__Scene__
#define __Tetris__Scene__

#import "./TexturedNode.h"
#include "./GameField.h"
#include <memory>

///
class Scene
	: public TexturedNode
{
public:
	Scene(const CGSize& size);
	bool HandleTap(const CGPoint& point) override;

private:
	std::shared_ptr<GameField> gameField_;
};

#endif /* defined(__Tetris__Scene__) */
