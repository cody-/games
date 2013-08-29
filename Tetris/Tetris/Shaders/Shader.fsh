//
//  Shader.fsh
//  Tetris
//
//  Created by cody on 8/29/13.
//  Copyright (c) 2013 local. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
