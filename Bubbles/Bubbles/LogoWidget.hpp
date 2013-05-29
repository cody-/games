//
//  LogoWidget.hpp
//  Bubbles
//
//  Created by cody on 5/21/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Bubbles__LogoWidget__
#define __Bubbles__LogoWidget__

#include "./ImgWidget.hpp"

///
class LogoWidget
	: public ImgWidget
{
public:
	LogoWidget(const Pnt<unsigned>& center);
	void Draw() override;

private:
	const Pnt<unsigned> center_;
	const int r_;
};

#endif /* defined(__Bubbles__LogoWidget__) */
