//
//  Node.h
//  Tetris
//
//  Created by cody on 9/9/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__Node__
#define __Tetris__Node__

#include "./ShaderProgram.h"
#import <GLKit/GLKit.h>
#include <vector>
#include <memory>

///
class Node
{
public:
	GLKVector2 position;
	CGSize contentSize;

	virtual void Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix);
	virtual void Update(float dt);
	virtual GLKMatrix4 ModelMatrix() const;
	virtual void HandleTap(const CGPoint& point);
	
	CGRect BoundingBox() const;

protected:
	std::vector<std::unique_ptr<Node>> children_;
};

#endif
