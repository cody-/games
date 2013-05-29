//
//  Utils.hpp
//  Bubbles
//
//  Created by cody on 5/20/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#ifndef __Bubbles__Utils__
#define __Bubbles__Utils__

#include <vector>
#include <random>

///
class BothSignDistribution
{
	std::vector<int> src_;
	std::uniform_int_distribution<> dist_;
public:
	BothSignDistribution(const int min, const int max)
		: dist_(0, 2*(max - min) - 1)
	{
		for (int i = -min; i > -max; --i) src_.push_back(i);
		for (int i = min; i < max; ++i) src_.push_back(i);
	}

	int operator()(std::mt19937& gn)
	{
		return src_[dist_(gn)];
	}
};

#endif /* defined(__Bubbles__Utils__) */
