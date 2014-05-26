//
//  SNeuron.m
//  ToughMan
//
//  Created by xu zhuoran on 5/26/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "SNeuron.h"

@implementation SNeuron
-(void)restartWithType:(neuron_type)type Id:(int)nid ActivationResponse:(double)ActResponse;
{
    _vecLinksIn=[NSMutableArray array];
    _vecLinksOut=[NSMutableArray array];
    _NeuronType=type;
    _iNeuronID=nid;
    _dActivationResponse=ActResponse;
    
    _dSumActivation=0;
    _dOutput=0;
    _dOutputTmp=0;
}
-(id)init
{
    self = [super init];
    if (self)
    {
        [self restartWithType:none Id:0 ActivationResponse:1];
    }
    
    return self;
}

-(id)initWithType:(neuron_type)type Id:(int)nid ActivationResponse:(double)ActResponse;
{
    self = [super init];
    if (self)
    {
        [self restartWithType:type Id:nid ActivationResponse:ActResponse];
    }
    
    return self;
}
@end
