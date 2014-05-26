//
//  CIOSToInternal.m
//  ToughMan
//
//  Created by xu zhuoran on 5/25/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CIOSToInternal.h"

@implementation CIOSToInternal
-(id)init
{
    self = [super init];
    if (self)
    {
        _mXRange = 0;//16
        _mYRange = 0;//16
        _winWidth = 0;
        _winHeight = 0;
        _rootNode = nil;
    }
    
    return self;
}

-(NxVec3*) IOSPositionToInternalPosition:(NxVec3*)point
{
    NxVec3* one=[[NxVec3 alloc] init];
    one.x=point.x/_winWidth*_mXRange;
    one.y=point.y/_winHeight*_mYRange;
    one.z=point.z;
    return one;
}
-(NxVec3*) InternalPositionToIOSPosition:(NxVec3*)point
{
    NxVec3* one=[[NxVec3 alloc] init];
    one.x=point.x/_mXRange*_winWidth;
    one.y=point.y/_mYRange*_winHeight;
    one.z=point.z;
    return one;
}
@end
