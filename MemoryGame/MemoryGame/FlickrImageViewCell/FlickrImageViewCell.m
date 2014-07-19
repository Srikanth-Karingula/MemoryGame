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
        self = [arrayOfViews objectAtIndex:0];
        
    }
    return self;
}



@end
