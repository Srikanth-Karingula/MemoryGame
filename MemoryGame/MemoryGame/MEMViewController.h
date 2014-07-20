//
//  MEMViewController.h
//  MemoryGame
//
//  Created by Administrator on 7/16/14.
//  Copyright (c) 2014 MEM. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MEMFlickrDataService.h"
#import "TJImageCache.h"
@interface MEMViewController : UIViewController<FlickrDataServiceDelegate, TJImageCacheDelegate>



@end
