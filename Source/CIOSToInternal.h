//
//  CIOSToInternal.h
//  ToughMan
//
//  Created by xu zhuoran on 5/25/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "NxVec3.h"

@interface CIOSToInternal : NSObject
@property double mXRange;
@property double mYRange;
@property double winWidth;
@property double winHeight;
@property (weak)CCNode* rootNode;

-(NxVec3*) IOSPositionToInternalPosition:(NxVec3*)point;
-(NxVec3*) InternalPositionToIOSPosition:(NxVec3*)point;

@end
