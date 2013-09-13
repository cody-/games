//
//  TextureLoader.mm
//  Tetris
//
//  Created by cody on 9/13/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "TextureLoader.h"

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
