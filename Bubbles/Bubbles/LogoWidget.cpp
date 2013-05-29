//
//  LogoWidget.cpp
//  Bubbles
//
//  Created by cody on 5/21/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./LogoWidget.hpp"
#include <iostream>

///
LogoWidget::LogoWidget(const Pnt<unsigned>& center)
	: ImgWidget("FireBall.png", GL_RGBA)
	, center_(center)
	, r_(100)
{
}

///
void LogoWidget::Draw()
{
	glLoadIdentity();
	glTranslated(center_.x, center_.y, 0);
	glEnable(GL_TEXTURE_2D);
	glBindTexture(GL_TEXTURE_2D, texture_);

	float currentColor[4];
	glGetFloatv(GL_CURRENT_COLOR, currentColor);
	glColor4f(1.0f, 1.0f, 1.0f, 0.65f);

	glBegin(GL_TRIANGLE_STRIP);
		glTexCoord2d(1, 1); glVertex2f(r_, r_); // Top Right
		glTexCoord2d(0, 1); glVertex2f(-r_, r_); // Top Left
		glTexCoord2d(1, 0); glVertex2f(r_, -r_); // Bottom Right
		glTexCoord2d(0, 0); glVertex2f(-r_, -r_); // Bottom Left
	glEnd();

	glColor4fv(currentColor);

	glDisable(GL_TEXTURE_2D);
}
