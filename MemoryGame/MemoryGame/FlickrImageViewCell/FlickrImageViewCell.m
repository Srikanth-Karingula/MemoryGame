//
//  FlickImageViewCell.m
//  MemoryGame
//
//  Created by Administrator on 7/16/14.
//  Copyright (c) 2014 MEM. All rights reserved.
//

#import "FlickrImageViewCell.h"


@implementation FlickrImageViewCell
@synthesize titleLabel;
@synthesize OverlayView;
@synthesize flickrImageView;
@synthesize activityIndicator;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"FlickrImageViewCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1)
        {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
//        flickrImageView = [[TJImageView alloc] initWithFrame:OverlayView.bounds];
//        [self addSubview:flickrImageView];
        self = [arrayOfViews objectAtIndex:0];
        
    }
    return self;
}

- (void) setImageDataToCell:(NSString *) imageUrl
{
    self.flickrImageView.image = [TJImageCache imageAtURL:imageUrl delegate:self];
}
#pragma mark - TJImageCacheDelegate
- (void)didGetImage:(IMAGE_CLASS *)image atURL:(NSString *)url
{
    flickrImageView.image = image;
}
- (void)didFailToGetImageAtURL:(NSString *)url
{
    NSLog(@"FAIL TO GET IMAGE AT URL %@", url);
}

@end
