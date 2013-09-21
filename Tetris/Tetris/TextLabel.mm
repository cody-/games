//
//  TextLabel.mm
//  Tetris
//
//  Created by cody on 9/21/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./TextLabel.h"
#include "./TextureLoader.h"

using namespace std;

///
TextLabel::TextLabel(string label, string fontName, unsigned fontSize)
	: TexturedNode(TextureLoader::Instance()->GetTextTexture(label, fontName, fontSize))
{
}
