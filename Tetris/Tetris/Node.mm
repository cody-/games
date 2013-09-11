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
	return GLKMatrix4Translate(modelMatrix, position.x, position.y, 0);
}

///
void Node::HandleTap(const CGPoint& point)
{

}

///
CGRect Node::BoundingBox() const
{
	return CGRectMake(position.x, position.y, contentSize.width, contentSize.height);
}
	
