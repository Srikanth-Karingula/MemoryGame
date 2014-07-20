//
//  MEMFlickrDataService.m
//  MemoryGame
//
//  Created by Administrator on 7/20/14.
//  Copyright (c) 2014 MEM. All rights reserved.
//

#import "MEMFlickrDataService.h"
#import "MEMGlobals.h"
#import "MEMFlickrImageEntity.h"
#import "MEMFlickrImageStore.h"

@implementation MEMFlickrDataService


-(instancetype)init
{
    if ( self = [super init])
    {
            _httpDataHandler = [[MEMDataService alloc] init];
            _httpDataHandler.OnFinishLoadingHandler = self;
    }
    return self;
}


-(void) loadStoreWithFlickrPublicApi
{
    NSString *flickrPublicUrl= kFlickrPublicUrl;
    NSMutableDictionary *httpRequestHeaders = [[NSMutableDictionary alloc]init];
    [httpRequestHeaders setObject:@"application/json" forKey:@"Accept"];
    [httpRequestHeaders setObject:@"application/json" forKey:@"Content-Type"];
    [_httpDataHandler processRequestWithURL:flickrPublicUrl httpRequestMethod:GET httpHeaders:httpRequestHeaders httpRequestBody:nil userData:nil];
    
    NSLog(@"getImagesFromFlickrPublicApi");
    
}
-(void) fillImageStoreWithFlickrResponse:(NSDictionary *) jsonData
{
    NSLog(@"Successfully parsed the flickr 'JSON' feed: %@", jsonData);
    
    NSArray *items = [jsonData objectForKey:@"items"];
    //Take top kNoOfImages
    if(items.count < kNoOfImages)
    {
        //MEM_STORE_RESULTS_ARE_LESS
        [self.flickrServiceDelegate unableToLoadStore:MEM_STORE_RESULTS_ARE_LESS];
    }
    else
    {
        [[MEMFlickrImageStore sharedStore] removeAllEntries];
        for(int i=0; i < kNoOfImages; i++)
        {
            NSDictionary *dictionary = items[i];
            MEMFlickrImageEntity * imageEntity = [[MEMFlickrImageEntity alloc] initWithDictionary:dictionary];
            [[MEMFlickrImageStore sharedStore] addImageEntity:imageEntity];
        }
        [self.flickrServiceDelegate loadedStoreWithData];
    }
}
-(void) parseFlickrResponse:(NSData *)response{
 
    NSString *dataAsString = [NSString stringWithUTF8String:[response bytes]];
    //remove the leading 'jsonFlickrFeed(' and trailing ')' from the response data so we are left with a dictionary root object
    NSString *correctedJSONString = [NSString stringWithString:[dataAsString substringWithRange:NSMakeRange (15, dataAsString.length-15-1)]];
    //correct by removing escape slash
    correctedJSONString = [correctedJSONString stringByReplacingOccurrencesOfString:@"\\'" withString:@"'"];
    //re-encode the now correct string representation of JSON back to a NSData object which can be parsed by NSJSONSerialization
    NSData *correctedData = [correctedJSONString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:correctedData options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        NSLog(@"Unable to parse!!!");
        //MEM_STORE_PARSE_ERROR
         [self.flickrServiceDelegate unableToLoadStore:MEM_STORE_PARSE_ERROR];
    }
    else {
        [self fillImageStoreWithFlickrResponse:json];
    }
}

#pragma mark - MEMDataService Delegates
-(void)didReceiveHttpResponse:(NSData *)response httpResponseCode:(NSInteger)httpResponseCode userData:(NSString *)userData
{

    if(httpResponseCode == 200 && response)
    {
        [self parseFlickrResponse:response];
        
    }
    else
    {
    //HANDLE ERRORS
        if(httpResponseCode >= 500)
        {
            [self.flickrServiceDelegate unableToLoadStore:MEM_STORE_SERVER_ERROR];
           
        }
        else
        {
            [self.flickrServiceDelegate unableToLoadStore:MEM_STORE_NETWORK_ERROR];
            
        }
        
    }
}
-(void)didHttpRequestCancel:(bool)isSuccess
{
    NSLog(@"Request Cancelled");
    if(isSuccess)
    {
        [self.flickrServiceDelegate unableToLoadStore:MEM_STORE_REQUEST_CANCELLED];
    }
}
-(void)didHttpRequestFailWithError:(NSError *)error httpResponseCode:(NSInteger)httpResponseCode userData:(NSString *)userData
{
    NSLog(@"Request to the server failed. The server returned the response code %d. Please see the below description:\n%@",httpResponseCode, [error description]);
   
    if(httpResponseCode >= 500)
    {
        [self.flickrServiceDelegate unableToLoadStore:MEM_STORE_SERVER_ERROR];
        
    }
    else
    {
        [self.flickrServiceDelegate unableToLoadStore:MEM_STORE_NETWORK_ERROR];
        
    }
}

@end
