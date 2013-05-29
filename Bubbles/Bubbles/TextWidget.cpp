//
//  TextWidget.cpp
//  Bubbles
//
//  Created by cody on 5/18/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./TextWidget.hpp"

using namespace std;

namespace
{
	const unsigned FONT_HEIGHT = 16;
	const unsigned FONT_WIDTH = 16;
	const unsigned LINE_SPACE = 10;
}

///
TextWidget::TextWidget(const Pnt<unsigned>& center)
	: ImgWidget("Font.bmp", GL_RGB)
	, center_(center)
{
	BuildFont();
}

///
TextWidget::~TextWidget()
{
	KillFont();
}

///
void TextWidget::Draw()
{
	glEnable(GL_TEXTURE_2D);
	glBindTexture(GL_TEXTURE_2D, texture_);
	for (int i = 0; i < txt_.size(); ++i)
	{
		const string& txt = txt_[i];

		GLfloat x = center_.x - FONT_WIDTH * txt.size()/2.0f;
		GLfloat y = center_.y + FONT_HEIGHT * (txt_.size()/2.0f - i - 1) - i * LINE_SPACE;

		glLoadIdentity();
		glTranslatef(x, y, 0);

		const int set = 0;
		glListBase(fontBase_ - 32 + (128 * set));
		
		// Write the text to the screen
		glCallLists((GLsizei)txt.size(), GL_UNSIGNED_BYTE, txt.c_str());
	}
	glDisable(GL_TEXTURE_2D);
}

///
TextWidget& TextWidget::Clear()
{
	txt_.clear();
	return *this;
}

///
TextWidget& TextWidget::operator<<(const string& txt)
{
	txt_.push_back(txt);
	return *this;
}

///
void TextWidget::BuildFont()
{
	fontBase_ = glGenLists(256);
	glBindTexture(GL_TEXTURE_2D, texture_);
	for (int i = 0; i < 256; ++i)
	{
		float cx = float(i % FONT_WIDTH)/FONT_WIDTH;
		float cy = float(i / FONT_HEIGHT)/FONT_HEIGHT;
		
		glNewList(fontBase_	+ i, GL_COMPILE);
			glBegin(GL_QUADS);
				glTexCoord2f(cx, 1.0f - cy - 0.0625f); glVertex2d(0, 0); // Bottom Left
				glTexCoord2f(cx + 0.0625f, 1.0f - cy - 0.0625f); glVertex2i(FONT_WIDTH, 0);	// Bottom Right
				glTexCoord2f(cx + 0.0625f, 1.0f - cy); glVertex2i(FONT_WIDTH, FONT_HEIGHT); // Top Right
				glTexCoord2f(cx, 1.0f - cy); glVertex2i(0, FONT_HEIGHT); // Top Left
			glEnd();
			glTranslated(15, 0, 0);
		glEndList();
	}
}

///
void TextWidget::KillFont()
{
	glDeleteLists(fontBase_, 256);
}
