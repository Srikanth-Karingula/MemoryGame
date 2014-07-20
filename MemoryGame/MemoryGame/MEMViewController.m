//
//  MEMViewController.m
//  MemoryGame
//
//  Created by Administrator on 7/16/14.
//  Copyright (c) 2014 MEM. All rights reserved.
//

#import "MEMViewController.h"
#import "MEMGlobals.h"
#import "MEMFlickrImageEntity.h"
#import "MEMFlickrImageStore.h"
#import "MEMGameViewController.h"

@interface MEMViewController ()

@property (weak, nonatomic) IBOutlet UIButton *gameStartButton;
@property (weak, nonatomic) IBOutlet UILabel *gameStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;

@property (strong, nonatomic) MEMFlickrDataService *flickrDataService;
@property (nonatomic) bool imageStoreIsLoaded;
@property (nonatomic) NSInteger cacheCounter;
-(IBAction) startOrStopGame:(id)sender;
@end

@implementation MEMViewController

@synthesize flickrDataService;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _imageStoreIsLoaded = false;
        _cacheCounter =0;
    }
    return self;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.

    flickrDataService = [[MEMFlickrDataService alloc] init];
    flickrDataService.flickrServiceDelegate = self;
    [self addImagesToStore];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(IBAction) startOrStopGame:(id)sender
{
    if(_imageStoreIsLoaded)
    {
        MEMGameViewController *gameViewController = [[MEMGameViewController alloc] initWithNibName:@"MEMGameViewController" bundle:nil];
        
        [self presentViewController:gameViewController animated:YES completion:^{}];
        
    }
    else
    {
        [MEMGlobals showMessage:@"Loading game" withTitle:@"Please wait"];
    }
    
}
-(IBAction) reloadGameData:(id)sender
{
    NSLog(@"Reloading image store data");
    [self addImagesToStore];
    
}
#pragma mark - DataServices

- (void) addImagesToStore
{
    _gameStartButton.hidden = true;
    _reloadButton.hidden = true;
    _gameStatusLabel.text = @"Loading.. ";
    [flickrDataService loadStoreWithFlickrPublicApi];
    //FOR TESTING
   
    /*for(int i=0; i < kNoOfImages; i++)
     {
     MEMFlickrImageEntity * imageEntity = [[MEMFlickrImageEntity alloc] init];
     imageEntity.title = [NSString stringWithFormat:@"image-%d",i];
     imageEntity.authorId = [NSString stringWithFormat:@"%d",i];
     imageEntity.locationUrl = @"http://farm3.staticflickr.com/2937/14508970300_5162ff5e2d_m.jpg";
      //[NSString stringWithFormat:@"URL-%d",i];
     imageEntity.hideImage = false;
     
     [[MEMFlickrImageStore sharedStore] addImageEntity:imageEntity];
     }
    [self loadedStoreWithData];
     */
}

#pragma mark FlickDataServiceDelegates

- (void) loadedStoreWithData
{
    NSLog(@"Successfully loaded store");
    //Start caching images
    _cacheCounter =0;
    [self startCachingImages];
    _gameStatusLabel.text = @"Started caching..";

}
- (void) unableToLoadStore:(MEM_STORE_LOAD_ERROR) loadErrorCode
{
    NSLog(@"Unable to LoadStore");
    
    NSString *strErrorMessage;
    NSString *strTitleForError;
    NSString *strStatusOnLabel;
    switch(loadErrorCode)
    {
        case MEM_STORE_NETWORK_ERROR:
        {
            strErrorMessage = @"Network error occured";
            strTitleForError = @"Network Error";
            strStatusOnLabel = @"Try Reload";
            break;
        }
        case MEM_STORE_SERVER_ERROR:
        {
            strErrorMessage = @"Unable to reach server";
            strTitleForError = @"Server Error";
            strStatusOnLabel = @"Try Reload";
            break;
        }
        case MEM_STORE_PARSE_ERROR:
        {
            strErrorMessage = @"Unable to parse results";
            strTitleForError = @"Parse Error";
            strStatusOnLabel = @"Try Reload";
            break;
        }
        case MEM_STORE_RESULTS_ARE_LESS:
        {
            strErrorMessage = @"Received less results, Unable to start load store.";
            strTitleForError = @"Error";
            strStatusOnLabel = @"Try Reload";
            break;
        }
        case MEM_STORE_REQUEST_CANCELLED:
        {
            strErrorMessage = @"Network operation cancelled";
            strTitleForError = @"Error";
            strStatusOnLabel = @"Try Reload";
            break;
        }
        case MEM_STORE_UNKNOWN_ERROR:
        {
            strErrorMessage = @"Unknown error occured";
            strTitleForError = @"Error";
            strStatusOnLabel = @"Try Reload";
            break;
        }

    }
    [MEMGlobals showMessage:strErrorMessage withTitle:strTitleForError];
    _gameStatusLabel.text = strStatusOnLabel;
    _reloadButton.hidden = false;
}

#pragma mark - CacheImages
-(void) startCachingImages
{
    for(MEMFlickrImageEntity *entity in [[MEMFlickrImageStore sharedStore] allImages])
    {
        UIImage *tempImage = [TJImageCache imageAtURL:entity.locationUrl delegate:self];

        if(tempImage){
            //already cached image
            _cacheCounter++;
            if(_cacheCounter >=(kNoOfImages/2) )
            {
                [self cachingCompleted];
            }
        }
        
    }
}
-(void) cachingCompleted
{
      _gameStatusLabel.text = @"Game Loaded";
    _reloadButton.hidden = false;
    _gameStartButton.hidden = false;
    _imageStoreIsLoaded= true;

}
#pragma mark - TJImageCacheDelegate
- (void)didGetImage:(IMAGE_CLASS *)image atURL:(NSString *)url
{
    _cacheCounter++;
   if(_cacheCounter >=(kNoOfImages/2))
   {
       //Cache atleast 50% images
       [self cachingCompleted];
       //Cache completed
       
   }
}
- (void)didFailToGetImageAtURL:(NSString *)url
{
    
    NSLog(@"FAIL TO GET IMAGE AT URL %@", url);
}


@end
