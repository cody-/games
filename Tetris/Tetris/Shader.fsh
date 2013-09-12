//
//  Shader.fsh
//  Tetris
//
//  Created by cody on 9/6/13.
//  Copyright (c) 2013 local. All rights reserved.
//

uniform sampler2D texSampler;
uniform lowp vec4 color;
uniform bool useColor;

varying lowp vec2 texCoordVarying;

void main()
{
	lowp vec4 texColor = texture2D(texSampler, texCoordVarying);
	if (useColor)
		gl_FragColor = mix(texColor, color, texColor.a);
	else
		gl_FragColor = texColor;
}
