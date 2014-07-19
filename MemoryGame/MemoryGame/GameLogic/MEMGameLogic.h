//
//  MEMGameLogic.h
//  MemoryGame
//
//  Created by Administrator on 7/19/14.
//  Copyright (c) 2014 MEM. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, MEMGameState)
{
    MEMGameState_NOT_STARTED,
    MEMGameState_STARTED,
    MEMGameState_PLAYING,
    MEMGameState_PAUSED,
    MEMGameState_STOPPED,
    MEMGameState_LASTQUESTION,
    MEMGameState_COMPLETED
};
@interface MEMGameLogic : NSObject
-(void) startGame;
-(void) stopGame;

-(void) resetGame;
-(BOOL) resultForSelection :(NSInteger) selectedIndex;
-(NSInteger) getNewQuestionIndex;
-(NSInteger) getScore;
-(void) updateScore : (NSInteger) points;
-(void) resetScore;
-(MEMGameState) getGameStatus;

@end
