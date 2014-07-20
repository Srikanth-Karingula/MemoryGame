
//
//  MEMDataService.m
//  MemoryGame
//
//  Created by Administrator on 7/20/14.
//  Copyright (c) 2014 MEM. All rights reserved.
//

#import "MEMDataService.h"
#import "MEMGlobals.h"
@implementation MEMDataService

NSString *const HttpRequestMethodString[] = {@"GET", @"POST", @"PUT", @"HEAD", @"DELETE"};
NSInteger httpResponseCode = 0;
NSTimeInterval timeoutInterval = 30.0;

#pragma mark - Properties
@synthesize OnFinishLoadingHandler;
@synthesize UserData;

#pragma mark - API

-(void)processRequestWithURL:(NSString *)url httpRequestMethod:(HTTP_REQUEST_METHOD)httpRequestMethod httpHeaders:(NSDictionary *)httpHeaders httpRequestBody:(NSData *)httpRequestBody userData:(id)userData
{
    self.UserData=userData;
    @synchronized(self)
    {
        httpResponseCode = 0;
        _theRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeoutInterval];
        [_theRequest setAllHTTPHeaderFields:httpHeaders];
        [_theRequest setHTTPMethod:HttpRequestMethodString[httpRequestMethod]];
        switch (httpRequestMethod)
        {
            case HEAD:
                break;
            case GET:
                break;
            case POST:
                [_theRequest setHTTPBody:httpRequestBody];
                break;
            case PUT:
                [_theRequest setHTTPBody:httpRequestBody];
                break;
            case DELETE:
                break;
            default:
                break;
        }
        if(_theConnection && [_theConnection currentRequest])
            [_theConnection cancel]; // cancel the current request on the same instance before starting new request
        
        _theConnection = [[NSURLConnection alloc] initWithRequest:_theRequest delegate:self startImmediately:NO];
        [_theConnection scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
        [_theConnection start];
        NSLog(@"Connection started with URL: %@", [[_theRequest URL] absoluteString]);
        if(_theConnection)
            _serverResponseData=[NSMutableData data];
        else
            NSLog(@"Connection failed for URL: %@", [[_theRequest URL] absoluteString]);
    }
}
-(void) cancelCurrentRequest
{
    if(_theConnection && [_theConnection currentRequest])
    {
        [_theConnection cancel];
        NSLog(@"cancelled request = %@", [[[_theConnection currentRequest] URL] absoluteString]);
        [self.OnFinishLoadingHandler didHttpRequestCancel:YES];
        _theConnection = NULL;
    }
    else
    {
        [self.OnFinishLoadingHandler didHttpRequestCancel:NO];
    }
}
#pragma mark - HTTP Response Delegates
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    httpResponseCode = (int)[httpResponse statusCode];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_serverResponseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [self sendError:error];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"[connectionDidFinishLoading] Is main thread? %@", ([NSThread isMainThread] ? @"YES" : @"NO"));
    [self sendResponse:_serverResponseData];
}
- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace
{
	return [protectionSpace.authenticationMethod
			isEqualToString:NSURLAuthenticationMethodServerTrust];
}

- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge
{
	if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
	{
        NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        [challenge.sender useCredential:credential forAuthenticationChallenge:challenge];
	}
    
	[challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
}
#pragma mark - Private Methods
-(void)sendResponse:(NSData*)response
{
    if(self.OnFinishLoadingHandler && [self.OnFinishLoadingHandler respondsToSelector:@selector(didReceiveHttpResponse:httpResponseCode:userData:)])
    {
        [self.OnFinishLoadingHandler didReceiveHttpResponse:response httpResponseCode:httpResponseCode userData:self.UserData];
        _theConnection = NULL;
    }
}
-(void)sendError:(NSError *)error
{
    if(self.OnFinishLoadingHandler && [self.OnFinishLoadingHandler respondsToSelector:@selector(didHttpRequestFailWithError:httpResponseCode:userData:)])
    {
        [self.OnFinishLoadingHandler didHttpRequestFailWithError:error httpResponseCode:httpResponseCode userData:self.UserData];
        _theConnection = NULL;
    }
}
@end
