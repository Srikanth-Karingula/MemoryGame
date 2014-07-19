//
//  MEMViewController.h
//  MemoryGame
//
//  Created by Administrator on 7/16/14.
//  Copyright (c) 2014 MEM. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MEMViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *collectionViewContainer;
@property (weak, nonatomic) IBOutlet UIView *questionViewContainer;

@property (weak, nonatomic) IBOutlet UICollectionView *flickrImageCollection;

@property (weak, nonatomic) IBOutlet UILabel *timerUpdateLabel;
@property (weak, nonatomic) IBOutlet UIButton *gameStartButton;

-(IBAction) startOrStopGame:(id)sender;

@end
