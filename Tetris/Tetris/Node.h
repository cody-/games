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
	virtual void Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix);
	virtual void Update(float dt);
	virtual GLKMatrix4 ModelMatrix() const;
	virtual bool HandleTap(const CGPoint& point);
	virtual void SetPosition(CGPoint point);
	
	CGRect BoundingBox() const;

protected:
	CGPoint position_;
	CGSize contentSize_;
	std::vector<std::unique_ptr<Node>> children_;
};

#endif
