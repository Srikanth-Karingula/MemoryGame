//
//  MEMFlickrDataService.h
//  MemoryGame
//
//  Created by Administrator on 7/20/14.
//  Copyright (c) 2014 MEM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MEMDataService.h"

typedef NS_ENUM(NSInteger,  MEM_STORE_LOAD_ERROR){
    MEM_STORE_NETWORK_ERROR,
    MEM_STORE_SERVER_ERROR,
    MEM_STORE_PARSE_ERROR,
    MEM_STORE_RESULTS_ARE_LESS,
    MEM_STORE_REQUEST_CANCELLED,
    MEM_STORE_UNKNOWN_ERROR
};

@protocol FlickrDataServiceDelegate <NSObject>
@required
- (void) loadedStoreWithData;
- (void) unableToLoadStore:(MEM_STORE_LOAD_ERROR) loadErrorCode;
@end



@interface MEMFlickrDataService : NSObject<onFinishLoading>

@property (nonatomic, retain) MEMDataService *httpDataHandler;
@property (nonatomic, retain) id<FlickrDataServiceDelegate> flickrServiceDelegate;
-(void) loadStoreWithFlickrPublicApi;

@end
