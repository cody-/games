//
//  TextureLoader.mm
//  Tetris
//
//  Created by cody on 9/13/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "TextureLoader.h"
#import <QuartzCore/QuartzCore.h>

using namespace std;

TextureLoader* TextureLoader::pInstance_ = nullptr;

///
TextureLoader* TextureLoader::Instance()
{
	if (!pInstance_)
		pInstance_ = new TextureLoader();

	return pInstance_;
}

///
void TextureLoader::RemoveInstance()
{
	delete pInstance_;
	pInstance_ = nullptr;
}

///
GLKTextureInfo* TextureLoader::GetTexture(const string& name)
{
	try {
		return cache_.at(name);
	}
	catch (const std::out_of_range&)
	{
		GLKTextureInfo* texInfo = LoadTexture(name);
		if (texInfo)
			cache_[name] = texInfo;
		return texInfo;
	}
}

///
GLKTextureInfo* TextureLoader::GetTextTexture(string txt, string fontFamily, const int fontSize)
{
	const string name = txt + "_" + fontFamily + "_" + to_string(fontSize);
	
	try {
		return cache_.at(name);
	}
	catch (const std::out_of_range&)
	{
		GLKTextureInfo* texInfo = GenerateTextTexture(txt, fontFamily, fontSize);
		if (texInfo)
			cache_[name] = texInfo;
		return texInfo;
	}
}

///
GLKTextureInfo* TextureLoader::LoadTexture(const string& fileName)
{
	NSDictionary* options = @{GLKTextureLoaderOriginBottomLeft: @YES};
	NSError* error;
	GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithContentsOfFile:[[NSBundle mainBundle] pathForResource:[NSString stringWithUTF8String:fileName.c_str()] ofType:nil] options:options error:&error];
	if (textureInfo == nil)
	{
		NSLog(@"Error loading file %s: %@", fileName.c_str(), [error localizedDescription]);
		throw "Can't load texture";
	}

	return textureInfo;
}

///
GLKTextureInfo* TextureLoader::GenerateTextTexture(const string& txt, const string& fontFamily, const int fontSize)
{
//	NSLog(@"%@", [UIFont familyNames]);
//	NSLog(@"%@", [UIFont fontNamesForFamilyName:[NSString stringWithUTF8String:fontFamily.c_str()]]);

	NSString* text = [NSString stringWithUTF8String:txt.c_str()];

	// Make a UILabel with the string
	UIFont* font = [UIFont fontWithName:[NSString stringWithUTF8String:fontFamily.c_str()] size:fontSize];
	if (!font)
	{
		NSLog(@"Can't create UIFont");
		throw "Can't generate text texture";
	}
	CGSize size = [text sizeWithFont:font];
	
	CGRect frame;
	frame.origin = CGPointMake(0, 0);
	frame.size = size; // Probably must be the power of two
	
	UILabel *label = [[UILabel alloc]initWithFrame:frame];
	label.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0];
	label.text = text;
	label.textColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1];
	label.font = font;

	// Make a UIImage with the UILabel
	UIGraphicsBeginImageContext(label.frame.size);
	[[label layer] renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *layerImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();

	NSError* error;
	GLKTextureInfo* textureInfo = [GLKTextureLoader textureWithCGImage:layerImage.CGImage options:@{GLKTextureLoaderOriginBottomLeft: @YES} error:&error];
	if (textureInfo == nil)
	{
		NSLog(@"Error generating texture for text '%s' with font %s of size %d: %@", txt.c_str(), fontFamily.c_str(), fontSize, [error localizedDescription]);
		throw "Can't load texture";
	}

	return textureInfo;
}

