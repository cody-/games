//
//  BmpImgImpl.h
//  Bubbles
//
//  Created by cody on 5/18/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef Bubbles_BmpImgImpl_h
#define Bubbles_BmpImgImpl_h

#include "./BmpImg.h"

///
class BmpImgImpl
	: public BmpImg
{
public:
	BmpImgImpl(NSString* path);
	unsigned int Width() const override;
	unsigned int Height() const override;
	unsigned char* Data() override;
private:
	NSBitmapImageRep* imgRep_;
};

#endif
