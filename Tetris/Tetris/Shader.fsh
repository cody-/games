//
//  Shader.fsh
//  Tetris
//
//  Created by cody on 9/6/13.
//  Copyright (c) 2013 local. All rights reserved.
//

uniform sampler2D texture;
uniform lowp vec4 color;

varying lowp vec2 texCoordVarying;

void main()
{
    //gl_FragColor = vec4(0,1,0,1)*vec4(texture2D(texture,texCoordVarying).xyz,texture2D(texture,texCoordVarying).w);
	lowp vec4 texColor = texture2D(texture, texCoordVarying);
	gl_FragColor = mix(texColor, color, texColor.a);
}
