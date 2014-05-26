//
//  CNeuralNet.m
//  ToughMan
//
//  Created by xu zhuoran on 5/26/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CNeuralNet.h"
#import "SNeuron.h"
#import "SLink.h"
#include "rapidxml.hpp"
#include "rapidxml_utils.hpp"
#include <string>
#include <map>
using namespace std;
using namespace rapidxml;

@implementation CNeuralNet
-(void)restartWithNeurons:(NSMutableArray*)neurons Depth:(int)depth;
{
    _m_vecpNeurons = [neurons copy];
    
    _m_iDepth=depth;
    
    _mBias=1;
}
-(id)init
{
    self = [super init];
    if (self)
    {
        [self restartWithNeurons:[NSMutableArray array] Depth:0];
    }
    
    return self;
}

-(id)initWithNeurons:(NSMutableArray*)neurons Depth:(int)depth;
{
    self = [super init];
    if (self)
    {
        [self restartWithNeurons:neurons Depth:depth];
    }
    
    return self;
}

-(double)SigmoidNetinput:(double)netinput Response:(double)response
{
	return ( 1 / ( 1 + exp(-netinput / response)));
	//return (double)(2.0/(1.0+exp(-2.0*netinput))-1.0);
}

-(NSMutableArray*)UpdateInputs:(NSMutableArray*)inputs RunType:(run_type)type
{
	//
	//
    //create a vector to put the outputs into
    vector<double>	outputs;
    
    //if the mode is snapshot then we require all the neurons to be
    //iterated through as many times as the network is deep. If the
    //mode is set to active the method can return an output after
    //just one iteration
    int FlushCount = 0;
    
    if (type == snapshot)
    {
        FlushCount = _m_iDepth;
    }
    else
    {
        FlushCount = 1;
    }
    
    //iterate through the network FlushCount times
    for (int i=0; i<FlushCount; ++i)
    {
        //clear the output vector
        outputs.clear();
        
        //this is an index into the current neuron
        int cNeuron = 0;
        
        //first set the outputs of the 'input' neurons to be equal
        //to the values passed into the function in inputs
        while (((SNeuron*)_m_vecpNeurons[cNeuron]).NeuronType == input)
        {
            ((SNeuron*)_m_vecpNeurons[cNeuron]).dOutput = [inputs[cNeuron] doubleValue];
            
            ++cNeuron;
        }
        
        //set the output of the bias to 1
        cNeuron++;
        ((SNeuron*)_m_vecpNeurons[cNeuron]).dOutput = _mBias;
        
        //then we step through the network a neuron at a time
        while (cNeuron < [_m_vecpNeurons count])
        {
            //this will hold the sum of all the inputs x weights
            double sum = 0;
            
            //sum this neuron's inputs by iterating through all the links into
            //the neuron
            //for (int lnk=0; lnk<[((SNeuron*)_m_vecpNeurons[cNeuron]).vecLinksIn count]; ++lnk)
            for(SLink* oneLink in ((SNeuron*)_m_vecpNeurons[cNeuron]).vecLinksIn)
            {
                //get this link's weight
                double Weight = oneLink.dWeight;
                
                //get the output from the neuron this link is coming from
                double NeuronOutput = oneLink.pIn.dOutput;
                
                //add to sum
                sum += Weight * NeuronOutput;
            }
            
            //now put the sum through the activation function and assign the
            //value to this neuron's output
            double toutput = [self SigmoidNetinput:sum Response:((SNeuron*)_m_vecpNeurons[cNeuron]).dActivationResponse];
            ((SNeuron*)_m_vecpNeurons[cNeuron]).dOutputTmp = toutput;
            if (type != snapshot)
                ((SNeuron*)_m_vecpNeurons[cNeuron]).dOutput = toutput;
            
            if (((SNeuron*)_m_vecpNeurons[cNeuron]).NeuronType == output)
            {
                //add to our outputs
                outputs.push_back(toutput);
            }
            
            //next neuron
            ++cNeuron;
        }
        if (type == snapshot)
        {
            for (int kk = 0; kk <[_m_vecpNeurons count];kk++)
            {
                ((SNeuron*)_m_vecpNeurons[kk]).dOutput = ((SNeuron*)_m_vecpNeurons[kk]).dOutputTmp;
            }
        }
    }//next iteration through the network
    
//#if 0
//    
//    //the network needs to be flushed if this type of update is performed otherwise
//    //it is possible for dependencies to be built on the order the training data is
//    //presented
//    if (type == snapshot)
//    {
//        for (int n=0; n<m_vecpNeurons.size(); ++n)
//        {
//            m_vecpNeurons[n]->dOutput = 0;
//        }
//    }
//    
//#endif
    
    //return the outputs
    NSMutableArray* res=[NSMutableArray array];
    for (int i=0; i<outputs.size(); i++)
    {
        [res addObject:[NSNumber numberWithDouble:outputs[i]]];
    }
    return res;
    return nil;
}

-(void)ResetNeuronOutput
{
    for (SNeuron* one in _m_vecpNeurons)
    {
        one.dOutput=0;
    }
}
-(BOOL)Load:(NSString*)path
{
    
    if (path==nil)
    {
        return FALSE;
    }
    xml_document<> doc;
    try
    {
        file<> fdoc([path UTF8String]);
        doc.parse<0>(fdoc.data());
        //
        _m_vecpNeurons=[NSMutableArray array];
        xml_node<>* xmlNet = doc.first_node();
		
		xml_node<>* xmlNetworkDepth = xmlNet->first_node("iNetworkDepth");
        _m_iDepth = atoi(xmlNetworkDepth->value());
        
        xml_node<>* xmlBias = xmlNet->first_node("dBias");
        _mBias = atof(xmlBias->value());
        
        //
        NSMutableDictionary *idPointerMap = [[NSMutableDictionary alloc] init];
        xml_node<>* xmlNeurons = xmlNet->first_node("cNeurons");
        for (xml_node<>* xmlNeuron = xmlNeurons->first_node("cNeuron"); xmlNeuron!=NULL; xmlNeuron=xmlNeuron->next_sibling())
        {
            SNeuron* one=[[SNeuron alloc] init];
            
            xml_node<>* xmlNeuronType = xmlNeuron->first_node("eNeuronType");
            one.NeuronType = atoi(xmlNeuronType->value());
            
            xml_node<>* xmliNeuronID = xmlNeuron->first_node("iNeuronID");
            one.iNeuronID = atoi(xmliNeuronID->value());
            
            xml_node<>* xmldActivationResponse = xmlNeuron->first_node("dActivationResponse");
            one.dActivationResponse = atof(xmldActivationResponse->value());
            
            [idPointerMap setObject:one forKey:[NSNumber numberWithInt:one.iNeuronID]];
            
            xml_node<>* xmlvecLinksIn = xmlNeuron->first_node("vecLinksIn");
            for (xml_node<>* xmlLink = xmlvecLinksIn->first_node("cLink"); xmlLink!=NULL; xmlLink=xmlLink->next_sibling())
            {
                SLink* oneLink = [[SLink alloc] init];
                
                xml_node<>* xmlpIn = xmlLink->first_node("pIn");
                oneLink.inID = atoi(xmlpIn->value());
                
                xml_node<>* xmlpOut = xmlLink->first_node("pOut");
                oneLink.outID = atoi(xmlpOut->value());
                
                xml_node<>* xmldWeight = xmlLink->first_node("dWeight");
                oneLink.dWeight = atof(xmldWeight->value());
                
                xml_node<>* xmlbRecurrent = xmlLink->first_node("bRecurrent");
                oneLink.bRecurrent = atoi(xmlbRecurrent->value());
                
                [one.vecLinksIn addObject:oneLink];
            }
            
            xml_node<>* xmlvecLinksOut = xmlNeuron->first_node("vecLinksOut");
            for (xml_node<>* xmlLink = xmlvecLinksOut->first_node("cLink"); xmlLink!=NULL; xmlLink=xmlLink->next_sibling())
            {
                SLink* oneLink = [[SLink alloc] init];
                
                xml_node<>* xmlpIn = xmlLink->first_node("pIn");
                oneLink.inID = atoi(xmlpIn->value());
                
                xml_node<>* xmlpOut = xmlLink->first_node("pOut");
                oneLink.outID = atoi(xmlpOut->value());
                
                xml_node<>* xmldWeight = xmlLink->first_node("dWeight");
                oneLink.dWeight = atof(xmldWeight->value());
                
                xml_node<>* xmlbRecurrent = xmlLink->first_node("bRecurrent");
                oneLink.bRecurrent = atoi(xmlbRecurrent->value());
                
                [one.vecLinksOut addObject:oneLink];
            }
            
            [_m_vecpNeurons addObject:one];
        }
        //fix pointer
        for (SNeuron* one in _m_vecpNeurons)
        {
            for (SLink* oneLink in one.vecLinksIn)
            {
                oneLink.pIn = idPointerMap[[NSNumber numberWithInt:oneLink.inID]];
                oneLink.pOut = idPointerMap[[NSNumber numberWithInt:oneLink.outID]];
            }
            for (SLink* oneLink in one.vecLinksOut)
            {
                oneLink.pIn = idPointerMap[[NSNumber numberWithInt:oneLink.inID]];
                oneLink.pOut = idPointerMap[[NSNumber numberWithInt:oneLink.outID]];
            }
        }
    }
    catch(...)
    {
        return FALSE;
    }
 
    [self ResetNeuronOutput];
    return TRUE;
}
@end
