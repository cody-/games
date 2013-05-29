//
//  Resources.h
//  Bubbles
//
//  Created by cody on 5/18/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Bubbles__Resources__
#define __Bubbles__Resources__

#include "./BmpImg.h"
#include <map>
#include <string>

namespace Resources
{

BmpImg* LoadTexture(const std::string& name);
std::map<std::string, std::string> LoadSettings();

}

#endif /* defined(__Bubbles__Resources__) */
