//
//  SNeuron.h
//  ToughMan
//
//  Created by xu zhuoran on 5/26/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

//#import <Foundation/Foundation.h>

@interface SNeuron : NSObject

typedef NS_ENUM(int, neuron_type)
{
    input,
    hidden,
    output,
    bias,
    none
};

//all the links coming into this neuron
@property (copy)NSMutableArray* vecLinksIn;
//and out
@property (copy)NSMutableArray* vecLinksOut;
//what type of neuron is this?
@property neuron_type   NeuronType;
//its identification number
@property int           iNeuronID;
//sets the curvature of the sigmoid function
@property double        dActivationResponse;


//sum of weights x inputs
@property double dSumActivation;
//the output from this neuron
@property double dOutput;
@property double dOutputTmp;


-(id)initWithType:(neuron_type)type Id:(int)nid ActivationResponse:(double)ActResponse;
@end
