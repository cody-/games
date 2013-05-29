//
//  BmpImg.h
//  Bubbles
//
//  Created by cody on 5/18/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Bubbles__BmpImg__
#define __Bubbles__BmpImg__

#include <string>

class BmpImg
{
public:
	virtual ~BmpImg() {}
	virtual unsigned int Width() const = 0;
	virtual unsigned int Height() const = 0;
	virtual unsigned char* Data() = 0;
};

#endif /* defined(__Bubbles__BmpImg__) */
