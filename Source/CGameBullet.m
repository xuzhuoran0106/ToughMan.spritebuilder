//
//  CGameBullet.m
//  ToughMan
//
//  Created by xu zhuoran on 5/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CGameBullet.h"


@implementation CGameBullet
{
    BOOL _IsScaled;
}
-(id)init
{
    self = [super init];
    if (self)
    {
        _mPos=[[NxVec3 alloc] initWithX:0 Y:0 Z:0];
        _mDirection =[[NxVec3 alloc] initWithX:0 Y:0 Z:0];
        _mVelocity=0;
        
        _mMap=nil;
        _mSize = 0.1;
        _IsScaled=FALSE;
    }
    
    return self;
}
- (void)update:(CCTime)delta
{
    if (_mMap!=nil)
    {
        if (!_IsScaled)
        {
            NSArray* children = self.children;
            CGSize contentSize=((CCNode*)children[0]).contentSize;
            NxVec3 *targetSize = [_mMap InternalPositionToIOSPosition:[[NxVec3 alloc]initWithX:2*_mSize Y:2*_mSize Z:0]];
            self.scaleX=targetSize.x/contentSize.width;
            self.scaleY=targetSize.y/contentSize.height;
            ((CCNode*)children[0]).visible=TRUE;
            _IsScaled=TRUE;
        }

        NxVec3 *point = [_mMap InternalPositionToIOSPosition:_mPos];
        //_position.x = point.x;
        //_position.y = point.y;
        self.position=ccp(point.x, point.y);
    }
}

- (void)Update
{
	_mPos.x = _mPos.x + _mDirection.x * _mVelocity;
    _mPos.y = _mPos.y + _mDirection.y * _mVelocity;
}
@end
