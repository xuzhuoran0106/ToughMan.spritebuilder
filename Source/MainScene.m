//
//  MainScene.m
//  PROJECTNAME
//
//  Created by Viktor on 10/10/13.
//  Copyright (c) 2013 Apportable. All rights reserved.
//

#import "MainScene.h"
#import "NxVec3.h"
#import "CGameFlight.h"
#import "CGameMap.h"

@implementation MainScene
{
    CGameFlight *_flight;
    CCButton *_restartButton;
    BOOL _gameOver;
    NSTimeInterval _time;
    CCLabelTTF *_scoreLabel;
    CGameMap* _mMap;
    CCNode* _rootNode;
    CCLabelTTF *_state;
}

- (void)didLoadFromCCB
{
    self.userInteractionEnabled = TRUE;
    _time=0;
    _gameOver=FALSE;
    CGSize winSize = [[CCDirector sharedDirector] viewSize];
    _mMap = [[CGameMap alloc]initWithX:winSize.width Y:winSize.height];
    _mMap.rootNode = _rootNode;
    _flight.mMap=_mMap;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ANN0" ofType:@"xml" inDirectory:(NSString *)@"ANN"];
    
    if ([_flight.m_pItsBrain Load:path])
    {
        _state.string = @"ANN loaded";
    }
    else
    {
        _state.string = @"Fail to load ANN";
    }
    
}

- (void)update:(CCTime)delta
{
    if (_time > 1.5f)
    {
        _state.string = @"";
    }
    if (!_gameOver)
    {   _time += delta;
        _scoreLabel.string = [NSString stringWithFormat:@"%f", _time];
        
        [_flight Update];
        [_mMap Update];
        [_flight finish];
        
        if (_flight.mDone)
        {
            [self gameOver];
        }
    }
    //
}

- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    if (!_gameOver)
    {
        // we want to know the location of our touch in this scene
        CGPoint currentPos = [touch locationInNode:self];
        _mMap.touchPoint=[[NxVec3 alloc] initWithX:currentPos.x Y:currentPos.y Z:0];
        [_mMap GenerateBullets];
    }
}

- (void)restart {
    CCScene *scene = [CCBReader loadAsScene:@"MainScene"];
    [[CCDirector sharedDirector] replaceScene:scene];
}

- (void)gameOver
{
    if (!_gameOver)
    {
        _gameOver = TRUE;
        _restartButton.visible = TRUE;
    }
}
@end
