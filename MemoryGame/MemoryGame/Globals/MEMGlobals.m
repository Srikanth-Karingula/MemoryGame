//
//  MEMGlobals.m
//  MemoryGame
//
//  Created by Administrator on 7/19/14.
//  Copyright (c) 2014 MEM. All rights reserved.
//

#import "MEMGlobals.h"

@implementation MEMGlobals

const NSInteger kNoOfImages = 9;
const NSInteger kNoOfImagesInRow = 3;
const NSInteger kShowTimeInSeconds = 15;
NSString * kFlickrPublicUrl = @"http://api.flickr.com/services/feeds/photos_public.gne?format=json&tags=data";
NSString *kGAMESTARTTEXT = @"START";
NSString *kGAMESTOPTEXT = @"STOP";

+ (void) logMessage:(NSString *) message
{
    NSLog(@"MemoryGame: %@",  message);
}

+ (void) logMessage:(NSString *) message from:(const char *) from
{
    NSLog(@"MemoryGame: %s:\n %@", from, message);
}

+ (void) showMessage:(NSString *) message withTitle: (NSString *) title
{
    [self logMessage:message from:ME];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    
}
@end
