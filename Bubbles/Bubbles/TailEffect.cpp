//
//  TailEffect.cpp
//  Bubbles
//
//  Created by cody on 5/21/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./TailEffect.hpp"
#include "./BubbleWidget.hpp"
#include <math.h>
#include <OpenGL/gl.h>
#include <iostream>

///
TailEffect::TailEffect(const BubbleWidget& base)
	: Effect(base)
{
}

/// Draw series of circles decreasing radius from (base radius + 70%) to 0.5
/// using white color with very small alpha
void TailEffect::Draw()
{
	const FPoint c = base_.Center();
	const Vector v = base_.Velocity();

	float currentColor[4];
	glGetFloatv(GL_CURRENT_COLOR, currentColor);
	glColor4f(1.0f, 1.0f, 1.0f, 0.03f);
	for (float r = base_.Radius()*1.7, d = 0; r > 0.5; r /= 1.125, d -= 0.05)
	{
		glLoadIdentity();
		glTranslatef(c.x + d*v.x, c.y + d*v.y, 0);
		const int segments = 2 * 3.14 * r;
			
		glBegin(GL_TRIANGLE_FAN);
			glVertex2f(0, 0);
			for(int n = 0; n <= segments; ++n ) {
				float const t = 2 * 3.14f * (float)n/(float)segments;
				glVertex2f(sin(t)*r, cos(t)*r);
			}
		glEnd();
	}
	glColor4fv(currentColor);
}
