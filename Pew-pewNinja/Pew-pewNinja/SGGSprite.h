//
//  SGGSprite.h
//  Pew-pewNinja
//
//  Created by cody on 9/3/13.
//  Copyright (c) 2013 local. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GLKit/GLKit.h>
#import "SGGNode.h"

@interface SGGSprite : SGGNode

- (id)initWithFile:(NSString*)fileName effect:(GLKBaseEffect*)effect;

@end
