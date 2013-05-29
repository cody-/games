//
//  BubbleState.cpp
//  Bubbles
//
//  Created by cody on 5/18/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./BubbleState.hpp"
#include "./BubbleWidget.hpp"
#include <OpenGL/glu.h>
#include <math.h>

///
BubbleState::BubbleState(BubbleWidget& owner)
	: owner_(owner)
{
}

///
void BubbleState::SetUp()
{
}

///
void BubbleState::TearDown()
{
}

///
void BubbleState::Update(const float dt)
{
}

///
void BubbleState::Draw()
{
	glLoadIdentity();
	glTranslatef(owner_.center_.x, owner_.center_.y, 0);
	glRotatef(owner_.rotation_, 0, 0, 1);
	glEnable(GL_TEXTURE_2D);
	glBindTexture(GL_TEXTURE_2D, owner_.texture_);

	const float r = owner_.radius_ * 1.25f; // 25% for the half-transparent shine
	glBegin(GL_TRIANGLE_STRIP);
		glTexCoord2d(1, 1); glVertex2f(r, r); // Top Right
		glTexCoord2d(0, 1); glVertex2f(-r, r); // Top Left
		glTexCoord2d(1, 0); glVertex2f(r, -r); // Bottom Right
		glTexCoord2d(0, 0); glVertex2f(-r, -r); // Bottom Left
	glEnd();

	glDisable(GL_TEXTURE_2D);
}

///
bool BubbleState::Dead() const
{
	return false;
}
