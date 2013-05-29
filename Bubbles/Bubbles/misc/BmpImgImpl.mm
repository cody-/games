//
//  BmpImgImpl.mm
//  Bubbles
//
//  Created by cody on 5/18/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./BmpImgImpl.h"

///
BmpImgImpl::BmpImgImpl(NSString* path)
{
	NSImage* img = [[NSImage alloc] initWithContentsOfFile:path]; 
	[img setFlipped:YES];
	imgRep_ = [[NSBitmapImageRep alloc] initWithCGImage:[img CGImageForProposedRect:nil context:nil hints:nil]];
	if (imgRep_ == nil)
	{
		NSLog(@"Unable to load file: %@", path);
		return;
	}
}

///
unsigned int BmpImgImpl::Width() const
{
	return static_cast<unsigned int>([imgRep_ pixelsWide]);
}

///
unsigned int BmpImgImpl::Height() const
{
	return static_cast<unsigned int>([imgRep_ pixelsHigh]);
}

///
unsigned char* BmpImgImpl::Data()
{
	return [imgRep_ bitmapData];
}
