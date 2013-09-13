//
//  TextureLoader.h
//  Tetris
//
//  Created by cody on 9/13/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Tetris__TextureLoader__
#define __Tetris__TextureLoader__

#include <map>
#include <string>
#import <GLKit/GLKit.h>

///
class TextureLoader
{
public:
	static TextureLoader* Instance();
	static void RemoveInstance();

	GLKTextureInfo* GetTexture(const std::string& name);

private:
	static GLKTextureInfo* LoadTexture(const std::string& fileName);

	static TextureLoader* pInstance_;
	std::map<std::string, GLKTextureInfo*> cache_;
};

#endif /* defined(__Tetris__TextureLoader__) */
