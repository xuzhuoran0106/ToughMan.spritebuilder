//
//  CNeuralNet.h
//  ToughMan
//
//  Created by xu zhuoran on 5/26/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

//#import <Foundation/Foundation.h>


@interface CNeuralNet : NSObject
typedef NS_ENUM(int, run_type)
{
    snapshot,
    active
};

-(NSMutableArray*)UpdateInputs:(NSMutableArray*)inputs RunType:(run_type)type;
-(void)ResetNeuronOutput;

@property double mBias;
@property (copy) NSMutableArray*  m_vecpNeurons;
@property int m_iDepth;

-(id)initWithNeurons:(NSMutableArray*)neurons Depth:(int)depth;
-(BOOL)Load:(NSString*)path;
@end
