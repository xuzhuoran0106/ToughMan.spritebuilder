//
//  NxVec3.h
//  ToughMan
//
//  Created by xu zhuoran on 5/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NxVec3 : NSObject <NSCopying>
@property double x;
@property double y;
@property double z;

-(id)initWithX:(double)px Y:(double)py Z:(double)pz;
-(double)normalize;
-(double)magnitude;
-(double)distance:(NxVec3*)v;
@end
