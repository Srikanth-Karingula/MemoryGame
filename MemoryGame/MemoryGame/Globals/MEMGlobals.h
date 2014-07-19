//
//  MEMGlobals.h
//  MemoryGame
//
//  Created by Administrator on 7/19/14.
//  Copyright (c) 2014 MEM. All rights reserved.
//

#import <Foundation/Foundation.h>
#define ME __PRETTY_FUNCTION__
@interface MEMGlobals : NSObject

extern const NSInteger kNoOfImages ; //UT
extern const NSInteger kNoOfImagesInRow ; //UT
extern const NSInteger kShowTimeInSeconds;
extern NSString *kGAMESTARTTEXT;
extern NSString *kGAMESTOPTEXT;

extern const NSString *kFlickrPublicUrl;

+ (void) logMessage:(NSString *) message;
+ (void) logMessage:(NSString *) message from:(const char *) from;
+ (void) showMessage:(NSString *) message withTitle: (NSString *) title;

@end
