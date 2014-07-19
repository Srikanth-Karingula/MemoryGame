//
//  MEMFlickrImageStore.m
//  MemoryGame
//
//  Created by Administrator on 7/19/14.
//  Copyright (c) 2014 MEM. All rights reserved.
//

#import "MEMFlickrImageStore.h"
#import "MEMFlickrImageEntity.h"

@interface MEMFlickrImageStore()
@property (nonatomic,strong) NSMutableArray *privateEntities;
@end

@implementation MEMFlickrImageStore

-(instancetype) initPrivate
{
    self = [super init];
    if(self)
    {
        _privateEntities = [[NSMutableArray alloc] init];
    }
    return  self;
}

+(instancetype) sharedStore
{
    static MEMFlickrImageStore *sharedStore;
    if(!sharedStore)
    {
        sharedStore = [[self alloc] initPrivate];
    }
    return sharedStore;
}

-(instancetype) init
{
    NSLog(@"This is a Singleton. Usage: [MEMFlickrImageStore sharedStore]");
    return  nil;
}

-(NSArray *) allImages
{
    return [self.privateEntities copy];
}

-(void) addImageEntity : (MEMFlickrImageEntity *) imageEntity
{
    [self.privateEntities addObject:imageEntity];
    
}

-(void) hideAllImages
{
    NSMutableArray *arrayTemp = [self.privateEntities copy];
    [self.privateEntities removeAllObjects];
    for (MEMFlickrImageEntity* imageEntity in arrayTemp )
    {
        imageEntity.hideImage = true;
        [self.privateEntities addObject:imageEntity];
    }
    
}



-(void) updateImageEntityToShowAtIndex:(NSInteger) index
{
    MEMFlickrImageEntity *imageEntity = [self.privateEntities objectAtIndex:index];
    imageEntity.hideImage = false;
    [self.privateEntities removeObjectAtIndex:index];
    [self.privateEntities insertObject:imageEntity atIndex:index];
    
}
@end
