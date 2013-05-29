//
//  ImgWidget.hpp
//  Bubbles
//
//  Created by cody on 5/21/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Bubbles__ImgWidget__
#define __Bubbles__ImgWidget__

#include "./Widget.hpp"
#include "./misc/BmpImg.h"

#include <memory>
#include <OpenGL/gl.h>

///
class ImgWidget
	: public Widget
{
public:
	ImgWidget(const std::string& imgName, const int format);
	virtual ~ImgWidget() = default;

protected:
	void LoadTexture(const int format);

	std::unique_ptr<BmpImg> img_;
	GLuint texture_;
};

#endif /* defined(__Bubbles__ImgWidget__) */
