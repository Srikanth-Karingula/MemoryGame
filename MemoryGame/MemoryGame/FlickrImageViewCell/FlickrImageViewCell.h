//
//  FlickImageViewCell.h
//  MemoryGame
//
//  Created by Administrator on 7/16/14.
//  Copyright (c) 2014 MEM. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TJImageView.h"
#import "TJImageCache.h"

@interface FlickrImageViewCell : UICollectionViewCell <TJImageCacheDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *OverlayView;
@property (weak, nonatomic) IBOutlet UIImageView *flickrImageView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (void) setImageDataToCell:(NSString *) imageUrl;

@end
