//
//  CGameMap.m
//  ToughMan
//
//  Created by xu zhuoran on 5/24/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "CGameMap.h"
#import "CRand.h"

@implementation CGameMap
-(void)restartX:(double)px Y:(double)py
{
    _mTarget=[[NxVec3 alloc] initWithX:0 Y:0 Z:0];
    _mBullet = [NSMutableArray array];
    _touchPoint = [[NxVec3 alloc] initWithX:0 Y:0 Z:0];
    _mTicks=0;
    _mNumBullet=50;
    _mInterval=30;
    self.winWidth = px;
    self.winHeight = py;
    
    self.mXRange = 16.0/py*px;
    self.mYRange = 16;

}
-(id)init
{
    self = [super init];
    if (self)
    {
        [self restartX:16 Y:16];
    }
       
    return self;
}
-(id)initWithX:(double)px Y:(double)py
{
    self = [super init];
    if (self)
    {
        [self restartX:px Y:py];
    }
    
    return self;
}
- (void)Update
{
    _mTicks++;
	
	//if(_mTicks%_mInterval==0||[_mBullet count]<_mNumBullet/5)
	//	[self GenerateBullets];
	
	[self UpdatePosition];
}
- (void)UpdatePosition
{
	[self UpdateBullets];
    
    //UpdateGenerator();
}
- (void)GenerateBullets
{
	_mTarget=[self IOSPositionToInternalPosition:_touchPoint];
    _mTarget.x=_mTarget.x-self.mXRange/2.0;
    _mTarget.y=_mTarget.y-self.mYRange/2.0;
    
    //NSLog(@"X:%f,Y:%f", _mTarget.x,_mTarget.y);
	NxVec3 *target=_mTarget;
	for (int i=0;i<_mNumBullet/5;i++)
	{
		//if([_mBullet count]>_mNumBullet)
		//	break;
        
		int side=rand()%4;
		
		//CGameBullet *newOne=[[CGameBullet alloc] init];
        CGameBullet *newOne = (CGameBullet *)[CCBReader load:@"Enemy"];
        newOne.mMap=self;
        [self.rootNode addChild:newOne];
        //[_physicsNode addChild:obstacle];

//		if(point.x > mXRange/2.0) return true;
//         if(point.x < -mXRange/2.0)  return true;
//         if(point.y > mYRange/2.0)  return true;
//         if(point.y < -mYRange/2.0)  return true;
        
        if (side==0)
		{
			newOne.mPos.x = self.mXRange/2.0;
			newOne.mPos.y = [CRand RandomClamped] * self.mYRange / 2.0;
			newOne.mPos.z = 0;
		}
		else if (side==1)
		{
			newOne.mPos.x = -self.mXRange/2.0;
			newOne.mPos.y = [CRand RandomClamped] * self.mYRange / 2.0;
			newOne.mPos.z = 0;
		}
		else if (side==2)
		{
			newOne.mPos.x = [CRand RandomClamped] * self.mXRange / 2.0;
			newOne.mPos.y = self.mYRange/2.0;
			newOne.mPos.z = 0;
		}
		else if (side==3)
		{
			newOne.mPos.x = [CRand RandomClamped] * self.mXRange / 2.0;
			newOne.mPos.y = -self.mYRange/2.0;
			newOne.mPos.z = 0;
		}
        
		
		newOne.mVelocity = 0.10;
		if (i==-1000)//0
		{
			newOne.mDirection.x = target.x-newOne.mPos.x;
			newOne.mDirection.y = target.y-newOne.mPos.y;
		}
		else
		{
			newOne.mDirection.x = target.x-newOne.mPos.x + [CRand RandomClamped] * self.mXRange / 10.0;
			newOne.mDirection.y = target.y-newOne.mPos.y + [CRand RandomClamped] * self.mYRange / 10.0;
		}
		
		newOne.mDirection.z = 0;
		[newOne.mDirection normalize];
        
        [_mBullet addObject:newOne];
	}
}

- (void)UpdateBullets
{
    NSMutableArray *discardedItems = [NSMutableArray array];
	for (CGameBullet *one in _mBullet)
	{
		[one Update];
        if ([self OutOfRange:one.mPos])
        {
            [discardedItems addObject:one];
        }
	}
    for (CGameBullet* one in discardedItems)
    {
        [_mBullet removeObject:one];
        [self.rootNode removeChild:one];
    }
}
- (BOOL)OutOfRange:(NxVec3*)point
{
	/*double difx=mXRange/10.0;
     double dify=mYRange/10.0;*/
	double difx=0;
	double dify=0;
	if(point.x > self.mXRange/2.0-difx) return true;
	if(point.x < -self.mXRange/2.0+difx)  return true;
	if(point.y > self.mYRange/2.0-dify)  return true;
	if(point.y < -self.mYRange/2.0+dify)  return true;
	return false;
}

@end
