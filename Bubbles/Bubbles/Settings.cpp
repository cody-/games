//
//  Settings.cpp
//  Bubbles
//
//  Created by cody on 5/20/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./Settings.hpp"
#include "./misc/Resources.h"
#include <iostream>

using namespace std;

///
Settings& Settings::Instance()
{
	static Settings instance;
	return instance;
}

///
Settings::Settings()
	: bubblesCount_(20)
	, lifeTime_(3.0)
	, bornTime_(2.0)
{
	map<string, string> settings = Resources::LoadSettings();
	try { bubblesCount_ = stoi(settings.at("CountPoints")); }	catch(...) { cout << "Using default value of " << bubblesCount_ << " for CountPoints" << endl; }
	try { lifeTime_ = stof(settings.at("LifeTime")); }			catch(...) { cout << "Using default value of " << lifeTime_ << " for LifeTime" << endl; }
	try { bornTime_ = stof(settings.at("BornTime")); }			catch(...) { cout << "Using default value of " << bornTime_ << " for BornTime" << endl; }
}

///
unsigned Settings::MinRadius()
{
	return 7;
}

///
unsigned Settings::MaxRadius()
{
	return 50;
}

///
unsigned Settings::BoomRadius()
{
	return 60;
}

///
unsigned Settings::MinVelocity()
{
	return 70;
}

///
unsigned Settings::MaxVelocity()
{
	return 120;
}

///
unsigned Settings::BubblesCount()
{
	return Instance().bubblesCount_;
}

///
unsigned Settings::UserShots()
{
	return 1;
}

///
float Settings::LifeTime()
{
	return Instance().lifeTime_;
}

///
float Settings::BornTime()
{
	return Instance().bornTime_;
}

///
float Settings::RotationSpeed()
{
	return -2;
}
