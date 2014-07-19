//
//  MEMViewController.m
//  MemoryGame
//
//  Created by Administrator on 7/16/14.
//  Copyright (c) 2014 MEM. All rights reserved.
//

#import "MEMViewController.h"
#import "MEMFlickrImageEntity.h"
#import "MEMFlickrImageStore.h"
#import "FlickrImageViewCell.h"
#import "MEMGlobals.h"
#import "MEMGameLogic.h"

@interface MEMViewController ()
@property (assign, nonatomic) bool isShowingImagesCollection;
@property (assign, nonatomic) NSInteger counter;//UT
@property (strong, nonatomic) NSTimer *timer;//UT
@property (strong, nonatomic) MEMGameLogic *gameLogicObject;
@end

@implementation MEMViewController
@synthesize flickrImageCollection;
@synthesize  collectionViewContainer;
@synthesize timer;
@synthesize gameLogicObject;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self addImagesToStore];
        self.isShowingImagesCollection = true;
        timer = nil;
        _counter = kShowTimeInSeconds;
        gameLogicObject = [[MEMGameLogic alloc] init];
        
    }
    return self;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [flickrImageCollection setDelegate:self];
    [flickrImageCollection setDataSource:self];
    
    [self.flickrImageCollection registerClass: [FlickrImageViewCell class] forCellWithReuseIdentifier:@"FlickrImageViewCell"];
   // [self getFlickrJson];
    [self toggleViews];
}

- (void) addImagesToStore
{
    for(int i=0; i < kNoOfImages; i++)
    {
        MEMFlickrImageEntity * imageEntity = [[MEMFlickrImageEntity alloc] init];
        imageEntity.name = [NSString stringWithFormat:@"image-%d",i];
        imageEntity.uniqueId = [NSString stringWithFormat:@"%d",i];
        imageEntity.locationUrl = [NSString stringWithFormat:@"URL-%d",i];
        imageEntity.hideImage = false;
        
        [[MEMFlickrImageStore sharedStore] addImageEntity:imageEntity];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - CollectionViewDelegate Implementation
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
   // int noOfImages = [[[MEMFlickrImageStore sharedStore] allImages] count];
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
   // int noOfImages = [[[MEMFlickrImageStore sharedStore] allImages] count];
    
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
    NSArray *imageEntities = [[MEMFlickrImageStore sharedStore] allImages];
    int indexValue = indexPath.section * kNoOfImagesInRow + indexPath.item;
    MEMFlickrImageEntity *imageEntity = imageEntities[indexValue];
    FlickrImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FlickrImageViewCell" forIndexPath:indexPath];
    cell.titleLabel.text = imageEntity.name;
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
        [[MEMFlickrImageStore sharedStore] updateImageEntityToShowAtIndex:indexValue];
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
        [self toggleViews];
        [self flipAllImages];
    }


}
-(void) flipAllImages
{
    [[MEMFlickrImageStore sharedStore] hideAllImages];
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
    [self.gameStartButton.titleLabel setText:kGAMESTOPTEXT] ;
    [gameLogicObject startGame];
    self.timerUpdateLabel.text = @"Find below image position";
    [self proceedToNextGameStep];
}

-(void) stopGame
{
    NSInteger score = [gameLogicObject getScore];
    [MEMGlobals showMessage:[NSString stringWithFormat:@"Game stopped!\n Your score is %d",score] withTitle:@"STOP"];
    [gameLogicObject stopGame];
    [self.gameStartButton.titleLabel setText:kGAMESTARTTEXT] ;

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
        self.timerUpdateLabel.text = [NSString stringWithFormat:@"%@",questionEntity.name];
    }
}
-(void) gameCompleted
{
    NSInteger score = [gameLogicObject getScore];
    [MEMGlobals showMessage:[NSString stringWithFormat:@"You Won the game!\n Your score is %d",score] withTitle:@"Congrats"];
    
    [self.gameStartButton.titleLabel setText:kGAMESTARTTEXT] ;
}
-(IBAction) startOrStopGame:(id)sender
{
    if([self.gameStartButton.titleLabel.text isEqualToString:kGAMESTARTTEXT])
    {
        [self startGame];
    }
    else
    {
        [self stopGame];
    }
}

#pragma mark - DataServices
-(void) getFlickrJson{
    NSURL *flickrFeedURL = [NSURL URLWithString:kFlickrPublicUrl];
    NSData *badJSON = [NSData dataWithContentsOfURL:flickrFeedURL];
    //convert to UTF8 encoded string so that we can manipulate the 'badness' out of Flickr's feed
    NSString *dataAsString = [NSString stringWithUTF8String:[badJSON bytes]];
    //remove the leading 'jsonFlickrFeed(' and trailing ')' from the response data so we are left with a dictionary root object
    NSString *correctedJSONString = [NSString stringWithString:[dataAsString substringWithRange:NSMakeRange (15, dataAsString.length-15-1)]];
    //correct by removing escape slash (note NSString also uses \ as escape character - thus we need to use \\)
    correctedJSONString = [correctedJSONString stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
    //re-encode the now correct string representation of JSON back to a NSData object which can be parsed by NSJSONSerialization
    NSData *correctedData = [correctedJSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:correctedData options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        NSLog(@"this still sucks - and we failed");
    }
    else {
        NSLog(@"we successfully parsed the flickr 'JSON' feed: %@", json);
        NSArray *items = [json objectForKey:@"items"];
        NSDictionary *item1 = [items objectAtIndex:0];
        NSLog(@"ITEM: %@", item1);
        NSLog(@"Title %@", [item1 objectForKey:@"title"]);

    }
}
@end
