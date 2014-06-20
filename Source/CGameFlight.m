//
//  CGameFlight.m
//  ToughMan
//
//  Created by xu zhuoran on 5/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CGameFlight.h"
#import "CCDrawingPrimitives.h"

@implementation CGameFlight
{
    BOOL _IsScaled;
}
-(id)init
{
    self = [super init];
    if (self)
    {
        [self restart];
    }
   
    return self;
}
-(void)restart
{
    //
    _mPos = [[NxVec3 alloc] initWithX:0 Y:0 Z:0];
    //_mMap = [[CGameMap alloc]init];
    _mMap=nil;
    _mDone=false;
    _mMove=[[NxVec3 alloc] initWithX:0 Y:0 Z:0];
    //
    _mNumSensorPieces = 18;
    _mNumSensorLayers = 5;
    _mSensorRadius = 1;
    //
    _mSize = 0.1;
    _mSpeed = 0.05;
    //
    _IsScaled=FALSE;
    //
    _m_Sensors = [NSMutableArray array];
    for (int i=0; i<_mNumSensorPieces*_mNumSensorLayers+2; i++)
    {
        [_m_Sensors addObject:[NSNumber numberWithDouble:0]];
    }
    _mSensorMap = [NSMutableArray array];
    for (int i=0; i<_mNumSensorPieces*_mNumSensorLayers; i++)
    {
        [_mSensorMap addObject:[NSNumber numberWithDouble:0]];
    }
    _ANNoutputs = [NSMutableArray array];
    for (int i=0; i<2; i++)
    {
        [_ANNoutputs addObject:[NSNumber numberWithDouble:0]];
    }
    
    _m_pItsBrain=[[CNeuralNet alloc] init];
}

- (void)didLoadFromCCB
{
    [self restart];
}
- (void)update:(CCTime)delta
{
    if (_mMap!=nil)
    {
        if (!_IsScaled)
        {
            NSArray* children = self.children;
            CGSize contentSize=((CCNode*)children[0]).contentSize;
            NxVec3 *targetSize = [_mMap InternalPositionToIOSPosition:[[NxVec3 alloc]initWithX:2*_mSize Y:2*_mSize Z:0]];
            self.scaleX=targetSize.x/contentSize.width;
            self.scaleY=targetSize.y/contentSize.height;
            ((CCNode*)children[0]).visible=TRUE;
            _IsScaled=TRUE;
        }

        NxVec3 *point = [_mMap InternalPositionToIOSPosition:_mPos];
       // _position.x = point.x;
       // _position.x=_position.x+200;
       // _position.y = point.y;
        self.position=ccp(point.x, point.y);
        //NSLog(@"flightX:%f,flightY:%f", point.x,point.y);
    }
}
- (void)Update
{
    if (!_mDone)
    {
        [self TestSensors];
        [self Calculate];
        [self Action:_ANNoutputs];
        //[self finish];
    }
}
- (void)TestSensors
{
    for (int i=0; i<_mNumSensorPieces*_mNumSensorLayers+2; i++)
    {
        _m_Sensors[i]=@0.0;
    }
    for (int i=0; i<_mNumSensorPieces*_mNumSensorLayers; i++)
    {
         _mSensorMap[i]=@0.0;
    }
	//////////////////
	[_mMove normalize];
	_m_Sensors[0]=[NSNumber numberWithDouble:_mMove.x];
	_m_Sensors[1]=[NSNumber numberWithDouble:_mMove.y];
    
	//NxVec3 dir=mTarget-mPos;
     //dir.normalize();
     //m_Sensors[3] = dir.x;
     //m_Sensors[4] = dir.y;
    
	int indexBase = 2;//0-35-->2-37
    
    NSMutableArray* bullets = _mMap.mBullet;
	for (CGameBullet* one in bullets)
    {
		NxVec3* oneBullet = one.mPos;
		
		double dis = [oneBullet distance:_mPos];
        
		int layer = dis / _mSensorRadius;//if mNumSensorLayers == 3, then layer == 0,1,2;
        
		if(layer > _mNumSensorLayers - 1)
			continue;
        
		//A(1,0) B(x,y) 1*x + 0*y = cosAB * |B|
        NxVec3* flightToBullet = [[NxVec3 alloc]init];
        flightToBullet.x=oneBullet.x - _mPos.x;
        flightToBullet.y=oneBullet.y - _mPos.y;
        flightToBullet.z=oneBullet.z - _mPos.z;
        
		double disFlightToBullet = [flightToBullet magnitude];
		double cosAB = flightToBullet.x / disFlightToBullet;
		double angleAB = acos(cosAB) * 180.0 / M_PI ;
		if(flightToBullet.y < 0)
			angleAB = 360 - angleAB;
		if (angleAB ==360 )
			angleAB =0;
        
		int piece = angleAB / (360.0/_mNumSensorPieces);
        
		_m_Sensors[indexBase + layer * _mNumSensorPieces + piece ] = @1.0;
		_mSensorMap[layer * _mNumSensorPieces + piece] = @1.0;
	}
}
-(void)draw
{
    if (_IsScaled)
    {
        //[self DrawSensors];
        [super draw];
    }
}
-(void)DrawSensors
{
    float dx,dy,lx,ly;
    dx=-_mMap.mXRange/2;
    dy=-_mMap.mYRange/2;
    lx=_mMap.mXRange;
    ly=_mMap.mYRange;
    
    NxVec3 *point = [[NxVec3 alloc] initWithX:_mSensorRadius Y:0 Z:0];
    point = [_mMap InternalPositionToIOSPosition:point];
    //because the node has been sacled
    double sensorRadius = point.x / self.scale;
    //
    //sensor
    for (int i=0;i<_mNumSensorLayers;i++)
    {
        //double onePiece = 360.0/_mNumSensorPieces;
        double onePiece = 2*M_PI/_mNumSensorPieces;
        for (int j=0;j<_mNumSensorPieces;j++)
        {
            double angle = onePiece * j;
            double order = 0;
            NxVec3 *color = [[NxVec3 alloc] initWithX:0 Y:1 Z:0];
            double sensorone = [(NSNumber*)_mSensorMap[i * _mNumSensorPieces + j] doubleValue];
            if(sensorone > 0.99)
            {
                order = 0.1;
                color = [[NxVec3 alloc] initWithX:1 Y:0 Z:0];
            }
            ccDrawColor4F(color.x,color.y,color.z,1);
            ////top
            //DrawCurve(mPos,mSensorRadius*i,angle,angle + onePiece,color,order);
            ccDrawArc(ccp(0,0),sensorRadius*i,angle,onePiece,10,FALSE);
            ////bottom
            //DrawCurve(mPos,mSensorRadius*i + mSensorRadius ,angle,angle + onePiece,color,order);
            ccDrawArc(ccp(0,0),sensorRadius*i + sensorRadius,angle,onePiece,10,FALSE);
            ////left
            //DrawLine(mPos,angle,mSensorRadius*i,mSensorRadius*i + mSensorRadius,color,order);
            double y = sin(angle);
            double x = cos(angle);
            ccDrawLine(ccp( x*(sensorRadius*i) , y*(sensorRadius*i) ),ccp( x*(sensorRadius*i + sensorRadius) , y*(sensorRadius*i + sensorRadius) ));
            ////right
            //DrawLine(mPos,angle + onePiece,mSensorRadius*i,mSensorRadius*i + mSensorRadius,color,order);
            y = sin(angle + onePiece);
            x = cos(angle + onePiece);
            ccDrawLine(ccp( x*(sensorRadius*i) , y*(sensorRadius*i) ),ccp( x*(sensorRadius*i + sensorRadius) , y*(sensorRadius*i + sensorRadius) ));
            
        }
    }
}
-(void)Calculate
{
    NSMutableArray *tmp=[_m_pItsBrain UpdateInputs:_m_Sensors RunType:snapshot];
    
    BOOL allZero=true;
    for (NSNumber* one in _m_Sensors)
    {
        if ([one doubleValue]!=0)
        {
            allZero = FALSE;
            break;
        }
    }
    if (allZero)
    {
        for (int i=0; i<2; i++)
        {
            _ANNoutputs[i]=@0.5;//tmp[i] @0.0
        }
        return;
    }
    for (int i=0; i<2; i++)
    {
        _ANNoutputs[i]=tmp[i];//tmp[i] @0.0
    }
}
- (void)Action:(NSMutableArray *)output
{
	double speed = _mSpeed;
	double dx = 0;
	double dy = 0;
    double outputone = 0;
    outputone = [(NSNumber*)output[0] doubleValue];
	if (outputone < 0.3)
		dx=-1;
	else if (outputone>0.6)
		dx=1;
	else
		dx=0;
    
    outputone = [(NSNumber*)output[1] doubleValue];
	if (outputone < 0.3)
		dy=-1;
	else if (outputone>0.6)
		dy=1;
	else
		dy=0;
    
	_mPos.x = _mPos.x + dx * speed;
	_mPos.y = _mPos.y + dy *speed;
    _mPos.z=0;
    
	_mMove.x=dx * speed;
	_mMove.y=dy *speed;
	_mMove.z=0;
    
	double difx=_mMap.mXRange/10.0;
	double dify=_mMap.mYRange/10.0;
    
	//sensor should be also modified
	if(_mPos.x > _mMap.mXRange/2.0 - difx)
     _mPos.x = _mPos.x-(_mMap.mXRange - 2*difx);
     if(_mPos.x < -_mMap.mXRange/2.0 + difx)
     _mPos.x = _mPos.x+(_mMap.mXRange - 2*difx);
     if(_mPos.y > _mMap.mYRange/2.0 - dify)
     _mPos.y = _mPos.y-(_mMap.mYRange - 2*dify);
     if(_mPos.y < -_mMap.mYRange/2.0 + dify)
     _mPos.y = _mPos.y+(_mMap.mYRange - 2*dify);

//	if(_mPos.x > _mMap.mXRange/2.0 - difx)
//		_mPos.x = _mMap.mXRange/2.0 - difx;
//	if(_mPos.x < -_mMap.mXRange/2.0 + difx)
//		_mPos.x = -_mMap.mXRange/2.0 + difx;
//	if(_mPos.y > _mMap.mYRange/2.0 - dify)
//		_mPos.y = _mMap.mYRange/2.0 - dify;
//	if(_mPos.y < -_mMap.mYRange/2.0 + dify)
//		_mPos.y = -_mMap.mYRange/2.0 + dify;
}


-(bool)finish
{
	for (CGameBullet* one in _mMap.mBullet)
	{
        double threshold = _mSize+one.mSize;

		if ([_mPos distance:one.mPos]<threshold)
		{
			_mDone = true;
//            NSArray* children = one.children;
//            ((CCNode*)children[0]).visible = FALSE;
//            ((CCNode*)children[1]).visible = TRUE;
			return true;
		}
	}
	return false;
}

@end
