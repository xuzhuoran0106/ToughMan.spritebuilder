//
//  SLink.m
//  ToughMan
//
//  Created by xu zhuoran on 5/26/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SLink.h"

@implementation SLink
-(void)restartWithWeight:(double)dW In:(SNeuron*)pin Out:(SNeuron*)pout Reccurrent:(BOOL)bRec
{
    _pIn=pin;
    _pOut=pout;
    _dWeight=dW;
    _bRecurrent=bRec;
    
    _inID=_outID=0;
    if (pin)
    {
        _inID=pin.iNeuronID;
    }
    if (pout)
    {
        _outID=pout.iNeuronID;
    }
}
-(id)init
{
    self = [super init];
    if (self)
    {
        [self restartWithWeight:0 In:nil Out:nil Reccurrent:false];
    }
    
    return self;
}

-(id)initWithWeight:(double)dW In:(SNeuron*)pin Out:(SNeuron*)pout Reccurrent:(BOOL)bRec
{
    self = [super init];
    if (self)
    {
        [self restartWithWeight:dW In:pin Out:pout Reccurrent:bRec];
    }
    
    return self;
}
@end
