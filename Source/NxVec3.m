//
//  NxVec3.m
//  ToughMan
//
//  Created by xu zhuoran on 5/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "NxVec3.h"

@implementation NxVec3
-(id)init
{
    self = [super init];
    if (self)
    {
         _x=_y=_z=0;
    }
   
    return self;
}
- (id)copyWithZone:(NSZone *)zone
{
    id one = [[NxVec3 alloc] initWithX:_x Y:_y Z:_z];
    return one;
}
-(id)initWithX:(double)px Y:(double)py Z:(double)pz;
{
    self = [super init];
    if (self)
    {
        _x=px;
        _y=py;
        _z=pz;
    }
   
    return self;
}
-(double)magnitude
{
    return sqrt(_x*_x+_y*_y+_z*_z);
}
-(double)normalize
{
    double m = [self magnitude];
	if (m)
    {
		double il =  1.0 / m;
		_x *= il;
		_y *= il;
		_z *= il;
    }
	return m;
}
-(double)distance:(NxVec3*)v
{
    double dx = _x - v.x;
	double dy = _y - v.y;
	double dz = _z - v.z;
    return sqrt(dx*dx+dy*dy+dz*dz);
}
@end
