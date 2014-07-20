//
//  MEMFlickrImageEntity.h
//  MemoryGame
//
//  Created by Administrator on 7/19/14.
//  Copyright (c) 2014 MEM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MEMFlickrImageEntity : NSObject

@property (strong, nonatomic) NSString * authorId;
@property (strong, nonatomic) NSString * title;
@property (strong, nonatomic) NSString * locationUrl;
@property (nonatomic) bool hideImage;

+(id) objectWithDictionary:(NSDictionary*)dictionary;
-(id) initWithDictionary:(NSDictionary*)dictionary;
@end
