//
//  MEMFlickrImageStore.h
//  MemoryGame
//
//  Created by Administrator on 7/19/14.
//  Copyright (c) 2014 MEM. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MEMFlickrImageEntity;

@interface MEMFlickrImageStore : NSObject

@property (readonly, nonatomic, copy) NSArray *allImages;

+(instancetype) sharedStore;
-(void) addImageEntity : (MEMFlickrImageEntity *) imageEntity;
-(void) removeAllEntries;
//-(void) hideAllImages;
//-(void) updateImageEntityToShowAtIndex:(NSInteger) index;
@end
