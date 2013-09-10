//
//  Node.h
//  Tetris
//
//  Created by cody on 9/9/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./ShaderProgram.h"
#import <GLKit/GLKit.h>
#include <vector>
#include <memory>

///
class Node
{
public:
	Node(const ShaderProgram& program);
	GLKVector2 position;
	CGSize contentSize;

	virtual void RenderWithModelViewMatrix(const GLKMatrix4& matrix);
	virtual void Update(float dt);
	virtual GLKMatrix4 ModelMatrix() const;
	virtual void HandleTap(const CGPoint& point);
	
	CGRect BoundingBox() const;

protected:
	const ShaderProgram& program_;
	std::vector<std::unique_ptr<Node>> children_;
};
