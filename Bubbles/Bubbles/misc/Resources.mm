//
//  Resources.mm
//  Bubbles
//
//  Created by cody on 5/18/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#include "./Resources.h"
#include "./BmpImgImpl.h"
#include <fstream>
#include <iostream>
#include <regex>

namespace Resources
{

using namespace std;

///
BmpImg* LoadTexture(const string& name)
{
	NSString* path = [[NSBundle mainBundle] pathForImageResource: [NSString stringWithCString:name.c_str() encoding:[NSString defaultCStringEncoding]]];
	return new BmpImgImpl(path);
}

///
map<string, string> LoadSettings()
{
	map<string, string> result;
	
	ifstream settingsFile([[[NSBundle mainBundle] pathForResource:@"input" ofType:@"txt"] UTF8String]);
	if (!settingsFile.is_open())
	{
		cout << "Warning: can't open config file" << endl;
		return result;
	}

	string line;
	regex r("([A-Za-z]+)\\s*=\\s*([0-9.]+)");
	smatch match;
	while (settingsFile.good())
	{
		getline(settingsFile, line);
		if (regex_match(line, match, r))
			result[match[1].str()] = match[2].str();
		else
			cout << "Warning: config line '" << line << "' has bad format" << endl;
	}

	settingsFile.close();
	return result;
}

} // namespace Resources

