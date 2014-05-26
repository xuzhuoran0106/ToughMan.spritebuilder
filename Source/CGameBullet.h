//
//  CGameBullet.h
//  ToughMan
//
//  Created by xu zhuoran on 5/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "NxVec3.h"
#import "CIOSToInternal.h"

@interface CGameBullet : CCSprite
@property (copy) NxVec3* mPos;
@property (copy) NxVec3* mDirection;
@property double mVelocity;

@property double mSize;
@property CIOSToInternal* mMap;

- (void)Update;
@end
