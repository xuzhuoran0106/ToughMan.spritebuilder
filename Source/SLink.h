//
//  SLink.h
//  ToughMan
//
//  Created by xu zhuoran on 5/26/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "SNeuron.h"

@interface SLink : NSObject
//pointers to the neurons this link connects
@property (weak)SNeuron*  pIn;
@property (weak)SNeuron*  pOut;

@property int inID;
@property int outID;

//the connection weight
@property double  dWeight;

//is this link a recurrent link?
@property BOOL    bRecurrent;

-(id)initWithWeight:(double)dW In:(SNeuron*)pin Out:(SNeuron*)pout Reccurrent:(BOOL)bRec;
@end
