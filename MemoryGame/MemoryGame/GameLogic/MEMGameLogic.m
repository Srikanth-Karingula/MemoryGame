//
//  MEMGameLogic.m
//  MemoryGame
//
//  Created by Administrator on 7/19/14.
//  Copyright (c) 2014 MEM. All rights reserved.
//

#import "MEMGameLogic.h"
#import "MEMGlobals.h"

@interface MEMGameLogic()

@property (nonatomic, strong) NSMutableArray *usedIndexArray;
@property (nonatomic, strong) NSMutableArray *availableIndexArray;

@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSInteger score;
@property (nonatomic) MEMGameState gameState;

@end

@implementation MEMGameLogic

-(instancetype) init
{
    self = [super init];
    if (self) {
        _usedIndexArray = [[NSMutableArray alloc] init];
        _availableIndexArray = [[NSMutableArray alloc] init];
        _score = 0;
        _currentIndex =-1;
        _gameState = MEMGameState_NOT_STARTED;
    }
    return self;
}

#pragma mark - GAME SETUP

-(void) initializeIndexArrays
{
    [_usedIndexArray removeAllObjects];
    [_availableIndexArray removeAllObjects];
    for(int i =0; i < kNoOfImages ; i++)
    {
        [_availableIndexArray addObject:[NSNumber numberWithInt:i]];
    }
}

-(void) startGame
{
    [self initializeIndexArrays];
    _gameState = MEMGameState_STARTED;
    /*
     startGame 
        - Get ImageList from Flickr
        - Download and Store Required No. of Images
        - ResetGame related objects
        - StartShowing images to user
     */
    
}
-(void) resetGame
{
    
    [self resetScore];
        
}

-(void) stopGame
{
    _gameState = MEMGameState_COMPLETED;
}
-(void) getRandomImagesList
{
    
}

#pragma mark - LOGIC

- (BOOL) resultForSelection:(NSInteger) selectedIndex
{
    if(selectedIndex == _currentIndex)
    {
        [self updateScore:1];
        if(_gameState == MEMGameState_LASTQUESTION)
        {
            _gameState = MEMGameState_COMPLETED;
        }
        return true;
    }
    else
    {
        return false;
    }
}

- (NSInteger) getNewQuestionIndex
{
    int arrayCount = _availableIndexArray.count;
   
    NSInteger randomIndex;
    if(arrayCount <=0)
    {
        return -1;
    }
    if(arrayCount>1)
    {
        _gameState = MEMGameState_PLAYING;
        randomIndex = arc4random() % (arrayCount - 1);
    }
    else if(arrayCount == 1)
    {
        _gameState = MEMGameState_LASTQUESTION;
        randomIndex = 0;
    }

    [_usedIndexArray addObject:_availableIndexArray[randomIndex]];
    _currentIndex = [[_availableIndexArray objectAtIndex:randomIndex] integerValue];
    [_availableIndexArray removeObjectAtIndex:randomIndex];
    NSLog(@"%d %d", randomIndex, _currentIndex);
    return _currentIndex;
    
}


#pragma mark - SCORE & STATUS

-(NSInteger) getScore
{
    return _score;
}

-(void) updateScore : (NSInteger) points
{
    _score+=points;
}

-(void) resetScore
{
    _score = 0;
}
-(MEMGameState) getGameStatus
{
    return _gameState;
}
@end
