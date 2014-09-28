//
//  RWWheelMenuItem.m
//  RWWheelMenuItem
//
//  Created by William REN on 9/26/14.
//  Copyright (c) 2014 China State Construction Engineering Co., LTD. All rights reserved.
//


#import "RWWheelMenuItem.h"

@implementation RWWheelMenuItem

@synthesize minValue, maxValue, midValue, value;

- (NSString *) description {
    
    return [NSString stringWithFormat:@"%i | %f, %f, %f", self.value, self.minValue, self.midValue, self.maxValue];
    
}

@end
