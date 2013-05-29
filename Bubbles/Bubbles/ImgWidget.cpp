//
//  ImgWidget.cpp
//  Bubbles
//
//  Created by cody on 5/21/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./ImgWidget.hpp"
#include "./misc/Resources.h"

///
ImgWidget::ImgWidget(const std::string& imgName, const int format)
	: img_(Resources::LoadTexture(imgName))
{
	LoadTexture(format);
}

///
void ImgWidget::LoadTexture(const int format)
{
	glGenTextures(1, &texture_);
	glBindTexture(GL_TEXTURE_2D, texture_);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
	glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
	glTexImage2D(GL_TEXTURE_2D, 0, format, img_->Width(), img_->Height(), 0, format, GL_UNSIGNED_BYTE, img_->Data());
}
