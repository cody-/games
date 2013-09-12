//
//  Node.mm
//  Tetris
//
//  Created by cody on 9/9/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#import "Node.h"
#include <algorithm>

using namespace std;

///
void Node::Render(const ShaderProgram& program, const GLKMatrix4& modelViewMatrix)
{
	GLKMatrix4 childModelViewMatrix = GLKMatrix4Multiply(modelViewMatrix, ModelMatrix());
	for_each(children_.begin(), children_.end(), [&](const unique_ptr<Node>& node) {
		node->Render(program, childModelViewMatrix);
	});
}

///
void Node::Update(float dt)
{
	for_each(children_.begin(), children_.end(), [&](const unique_ptr<Node>& node) {
		node->Update(dt);
	});
}

///
GLKMatrix4 Node::ModelMatrix() const
{
	GLKMatrix4 modelMatrix = GLKMatrix4Identity;
	return GLKMatrix4Translate(modelMatrix, position_.x, position_.y, 0);
}

/// @return true if this object will handle the tap, false if not
bool Node::HandleTap(const CGPoint& point)
{
	return false;
}

///
CGRect Node::BoundingBox() const
{
	return CGRectMake(position_.x, position_.y, contentSize_.width, contentSize_.height);
}

///
void Node::SetPosition(CGPoint point)
{
	position_ = point;
}
	
