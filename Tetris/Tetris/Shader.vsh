//
//  Shader.vsh
//  Tetris
//
//  Created by cody on 9/6/13.
//  Copyright (c) 2013 local. All rights reserved.
//

uniform mat4 modelViewProjectionMatrix;

attribute vec4 position;
attribute vec2 texCoord;

varying vec2 texCoordVarying;

void main()
{
    gl_Position = modelViewProjectionMatrix * position;
	texCoordVarying = texCoord;
}
