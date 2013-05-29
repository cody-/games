//
//  Settings.hpp
//  Bubbles
//
//  Created by cody on 5/20/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Bubbles__Settings__
#define __Bubbles__Settings__

///
class Settings
{
public:
	static unsigned MinRadius();
	static unsigned MaxRadius();
	static unsigned BoomRadius();
	static unsigned MinVelocity();
	static unsigned MaxVelocity();
	static unsigned BubblesCount();
	static unsigned UserShots();
	static float LifeTime();
	static float BornTime();
	static float RotationSpeed();

private:
	static Settings& Instance();
	Settings();

	unsigned bubblesCount_;
	float lifeTime_;
	float bornTime_;
};

#endif /* defined(__Bubbles__Settings__) */
