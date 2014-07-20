//
//  MEMGameViewController.m
//  MemoryGame
//
//  Created by Administrator on 7/20/14.
//  Copyright (c) 2014 MEM. All rights reserved.
//

#import "MEMGameViewController.h"
#import "MEMFlickrImageEntity.h"
#import "MEMFlickrImageStore.h"
#import "FlickrImageViewCell.h"
#import "MEMGlobals.h"
#import "MEMGameLogic.h"

@interface MEMGameViewController ()
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *collectionViewContainer;
@property (weak, nonatomic) IBOutlet UIView *questionViewContainer;
@property (weak, nonatomic) IBOutlet UICollectionView *flickrImageCollection;
@property (weak, nonatomic) IBOutlet UIImageView *questionImageView;

@property (weak, nonatomic) IBOutlet UILabel *timerUpdateLabel;
@property (assign, nonatomic) bool isShowingImagesCollection;
@property (assign, nonatomic) NSInteger counter;//UT
@property (strong, nonatomic) NSTimer *timer;//UT
@property (strong, nonatomic) MEMGameLogic *gameLogicObject;
@property (strong, nonatomic) NSArray *localStore;

@end

@implementation MEMGameViewController
@synthesize flickrImageCollection;
@synthesize  collectionViewContainer;
@synthesize timer;
@synthesize gameLogicObject;
@synthesize localStore;
@synthesize questionImageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isShowingImagesCollection = true;
    timer = nil;
    _counter = kShowTimeInSeconds;
    gameLogicObject = [[MEMGameLogic alloc] init];
    // Do any additional setup after loading the view from its nib.
     [flickrImageCollection setDelegate:self];
     [flickrImageCollection setDataSource:self];
    
    localStore= [[MEMFlickrImageStore sharedStore] allImages];
    [self.flickrImageCollection registerClass: [FlickrImageViewCell class] forCellWithReuseIdentifier:@"FlickrImageViewCell"];
    [self.flickrImageCollection reloadData];
    // [self getFlickrJson];
     [self toggleViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - CollectionViewDelegate Implementation
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
  
    if(kNoOfImages%kNoOfImagesInRow == 0)
    {
        return kNoOfImages/kNoOfImagesInRow;
    }
    else
    {
        return (kNoOfImages/kNoOfImagesInRow +1);
    }
    
    
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
   
    
    if(kNoOfImages%kNoOfImagesInRow == 0)
    {
        return kNoOfImagesInRow;
    }
    else
    {
        if(section == kNoOfImages/kNoOfImagesInRow)
            return kNoOfImages%kNoOfImagesInRow;
        else
            return kNoOfImagesInRow;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    

    int indexValue = indexPath.section * kNoOfImagesInRow + indexPath.item;
    MEMFlickrImageEntity *imageEntity = localStore[indexValue];
    FlickrImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FlickrImageViewCell" forIndexPath:indexPath];
   // cell.flickrImageView = [[TJImageView alloc] initWithFrame:cell.OverlayView.frame];
    
    [cell setImageDataToCell:imageEntity.locationUrl];
  
//    [cell.flickrImageView setImageURLString:imageEntity.locationUrl];
    cell.titleLabel.text = imageEntity.title;
    cell.flickrImageView.hidden = imageEntity.hideImage;
    cell.OverlayView.hidden = !imageEntity.hideImage;
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    int indexValue = indexPath.section * kNoOfImagesInRow + indexPath.item;
    if([gameLogicObject getGameStatus]!=MEMGameState_COMPLETED)
    {
        BOOL selectionResult = [gameLogicObject resultForSelection:indexValue];
        if(selectionResult)
        {
            FlickrImageViewCell *cell = (FlickrImageViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            cell.flickrImageView.hidden = false;
            cell.OverlayView.hidden = true;
            //[self updateImageEntityToShowAtIndex:indexValue];
            
            [self proceedToNextGameStep];
        }
        else
        {
            [MEMGlobals showMessage:@"Try again!" withTitle:@"Wrong Answer"];
        }
    }
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((collectionViewContainer.frame.size.width/kNoOfImagesInRow)-5, (collectionViewContainer.frame.size.height/kNoOfImagesInRow)-5);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    UIEdgeInsets insets = { .left = 2, .right = 0, .top = 2, .bottom = 0};
    return insets;
    
}

#pragma mark - UpdateViews

-(void) showTimerValue
{
    _counter--;
    self.timerUpdateLabel.text= [NSString stringWithFormat:@"%02d",_counter];
    if(_counter == 0)
    {
        [timer invalidate];
        self.isShowingImagesCollection = false;
        [self flipAllImages];
        [self toggleViews];
      
    }
    
    
}
-(void) flipAllImagesBack
{
    NSMutableArray *arrayTemp = [[NSMutableArray alloc] init];
    
    for (MEMFlickrImageEntity* imageEntity in localStore )
    {
        imageEntity.hideImage = false;
        [arrayTemp addObject:imageEntity];
    }
    localStore = arrayTemp;
}
-(void) flipAllImages
{
    NSMutableArray *arrayTemp = [[NSMutableArray alloc] init];
   
    for (MEMFlickrImageEntity* imageEntity in localStore )
    {
       imageEntity.hideImage = true;
        [arrayTemp addObject:imageEntity];
    }
    localStore = arrayTemp;
    [self.flickrImageCollection reloadData];
    [self startGame];
}

-(void)toggleViews
{
    CGRect rect1,rect2,rect3;
    if(self.isShowingImagesCollection)
    {
        rect1=self.headerView.frame;
        rect2 = self.collectionViewContainer.frame;
        rect3 = self.questionViewContainer.frame;
        rect2.size.height = 400;
        rect3.origin.y = rect2.origin.y+rect2.size.height;
    }
    else
    {
        rect1=self.headerView.frame;
        rect2 = self.collectionViewContainer.frame;
        rect3 = self.questionViewContainer.frame;
        rect2.size.height = 250;
        rect3.origin.y = rect2.origin.y+rect2.size.height;
    }
    [UIView animateWithDuration:0.5f animations:^{
        self.collectionViewContainer.frame=rect2;
        self.questionViewContainer.frame = rect3;
        
        
    }completion:^(BOOL finished){
        
        //START TIMER
        if(self.isShowingImagesCollection){
            
            timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(showTimerValue) userInfo:nil repeats:YES];
            self.timerUpdateLabel.text= [NSString stringWithFormat:@"%d",_counter];
            
        }
        
    }];
}
#pragma mark - GAME
-(void) startGame
{
    [gameLogicObject startGame];
    self.timerUpdateLabel.text = @"Find below image position";
    [self proceedToNextGameStep];
}

-(void) stopGame
{
    NSInteger score = [gameLogicObject getScore];
    [MEMGlobals showMessage:[NSString stringWithFormat:@"Game stopped!\n Your score is %d",score] withTitle:@"STOP"];
    [gameLogicObject stopGame];
}
-(void) proceedToNextGameStep
{
    if([gameLogicObject getGameStatus] == MEMGameState_COMPLETED)
    {
        [self gameCompleted];
    }
    else
    {
        [self getQuestionImageIndex];
    }
}
-(void) getQuestionImageIndex
{
    NSInteger questionIndex = [gameLogicObject getNewQuestionIndex];
    if(questionIndex == -1)
    {
        [MEMGlobals showMessage:[NSString stringWithFormat:@"Can not proceed :("] withTitle:@"Sorry"];
    }
    else
    {
        MEMFlickrImageEntity *questionEntity = [[[MEMFlickrImageStore sharedStore] allImages] objectAtIndex:questionIndex];
        self.timerUpdateLabel.text = @"Find below image location";
        [self setQuestionImageWithUrl:questionEntity.locationUrl];
       // self.timerUpdateLabel.text = [NSString stringWithFormat:@"%@",questionEntity.authorId];
    }
}
-(void) gameCompleted
{
    NSInteger score = [gameLogicObject getScore];
    [MEMGlobals showMessage:[NSString stringWithFormat:@"You Won the game!\n Your score is %d",score] withTitle:@"Congrats"];
    
}


-(IBAction) quitGame:(id)sender
{
    [self flipAllImagesBack];
    [self dismissViewControllerAnimated:YES completion:^{
    
    }];
}


- (void) setQuestionImageWithUrl:(NSString *) imageUrl
{
    self.questionImageView.image = [TJImageCache imageAtURL:imageUrl delegate:self];
}
#pragma mark - TJImageCacheDelegate
- (void)didGetImage:(IMAGE_CLASS *)image atURL:(NSString *)url
{
    questionImageView.image = image;
}
- (void)didFailToGetImageAtURL:(NSString *)url
{
    NSLog(@"FAIL TO GET IMAGE AT URL %@", url);
}


@end
