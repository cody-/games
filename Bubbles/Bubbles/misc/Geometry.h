//
//  Geometry.h
//  Bubbles
//
//  Created by cody on 5/17/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef Bubbles_Geometry_h
#define Bubbles_Geometry_h

///
template <typename T>
struct Pnt
{
	T x;
	T y;
};

///
using FPoint = Pnt<float>;
using Vector = Pnt<float>;

///
template <typename T>
T sqr(T x)
{
	return x * x;
}

///
template <typename T>
T distance2(const Pnt<T>& p1, const Pnt<T>& p2)
{
	return sqr(p2.x - p1.x) + sqr(p2.y - p1.y);
}

#endif
