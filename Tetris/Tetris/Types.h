//
//  Types.h
//  Tetris
//
//  Created by cody on 9/11/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef Tetris_Types_h
#define Tetris_Types_h

namespace Game
{

///
template <class T>
struct Point
{
	T x;
	T y;
};

///
template <class T>
struct Size
{
	T w;
	T h;
};

///
struct Line
{
	CGPoint p1;
	CGPoint p2;
};

} // namespace

using UPoint = Game::Point<unsigned int>;
using USize = Game::Size<unsigned int>;

#endif
