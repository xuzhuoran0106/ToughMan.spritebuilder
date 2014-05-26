//
//  CGameMap.h
//  ToughMan
//
//  Created by xu zhuoran on 5/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "NxVec3.h"
#import "CIOSToInternal.h"
#import "CGameBullet.h"

@interface CGameMap : CIOSToInternal

@property (copy)NxVec3* touchPoint;
@property (copy)NxVec3* mTarget;
@property (copy)NSMutableArray* mBullet;
@property int mTicks;
@property int mNumBullet;
@property int mInterval;

- (void)Update;
- (void)GenerateBullets;
-(id)initWithX:(double)px Y:(double)py;
@end
