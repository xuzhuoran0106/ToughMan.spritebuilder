//
//  CRand.m
//  ToughMan
//
//  Created by xu zhuoran on 5/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CRand.h"

#define ARC4RANDOM_MAX      0x100000000
@implementation CRand
+(double)RandomClamped
{
    // value between 0.f and 1.f
    double random = ((double)arc4random() / ARC4RANDOM_MAX);
    return 2.0*(random-0.5);
}
@end
