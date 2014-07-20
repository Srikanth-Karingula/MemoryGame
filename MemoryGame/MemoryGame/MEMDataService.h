//
//  MEMDataService.h
//  MemoryGame
//
//  Created by Administrator on 7/20/14.
//  Copyright (c) 2014 MEM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol onFinishLoading <NSObject>

@required
- (void) didReceiveHttpResponse:(NSData *) response httpResponseCode:(NSInteger) httpResponseCode userData:(NSString*)userData;
- (void) didHttpRequestFailWithError:(NSError *) error httpResponseCode:(NSInteger) httpResponseCode userData:(NSString*)userData;
- (void) didHttpRequestCancel:(bool) isSuccess;

@end

typedef NS_ENUM(NSInteger,  HTTP_REQUEST_METHOD){
    GET = 0,
    POST = 1,
    PUT = 2,
    HEAD = 3,
    DELETE = 4
};

@interface MEMDataService : NSObject

@property (nonatomic, retain) id<onFinishLoading> OnFinishLoadingHandler;
@property (nonatomic, retain) NSURLConnection *theConnection;
@property (nonatomic, retain) NSMutableData *serverResponseData;
@property (nonatomic, retain) NSMutableURLRequest *theRequest;
@property (nonatomic, retain) id UserData;

-(void)processRequestWithURL:(NSString *)url httpRequestMethod:(HTTP_REQUEST_METHOD)httpRequestMethod httpHeaders:(NSDictionary *)httpHeaders httpRequestBody:(NSData *)httpRequestBody userData:(id)userData;
- (void) cancelCurrentRequest;
@end

