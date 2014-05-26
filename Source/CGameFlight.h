//
//  CGameFlight.h
//  ToughMan
//
//  Created by xu zhuoran on 5/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CCSprite.h"
#import "CGameMap.h"
#import "NxVec3.h"
#import "CNeuralNet.h"

@interface CGameFlight : CCSprite
@property (copy)NxVec3* mPos;
@property (weak)CGameMap* mMap;
@property BOOL mDone;
@property (copy)NxVec3* mMove;
@property int mNumSensorPieces;
@property int mNumSensorLayers;
@property double mSensorRadius;
@property double mSize;
@property double mSpeed;
@property (copy)NSMutableArray* m_Sensors;
@property (copy)NSMutableArray* mSensorMap;
@property (copy)NSMutableArray* ANNoutputs;

@property (copy)CNeuralNet* m_pItsBrain;

-(bool)finish;
- (void)Update;
@end
