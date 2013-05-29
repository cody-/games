//
//  TextWidget.hpp
//  Bubbles
//
//  Created by cody on 5/18/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Bubbles__TextWidget__
#define __Bubbles__TextWidget__

#include "./ImgWidget.hpp"

#include <vector>
#include <OpenGL/gl.h>

///
class TextWidget
	: public ImgWidget
{
public:
	TextWidget(const Pnt<unsigned>& center);
	~TextWidget();
	void Draw() override;
	TextWidget& Clear();
	TextWidget& operator<<(const std::string& txt); /// Add line

private:
	void BuildFont();
	void KillFont();

	const Pnt<unsigned> center_;
	GLuint fontBase_;
	std::vector<std::string> txt_;
};

#endif /* defined(__Bubbles__TextWidget__) */
