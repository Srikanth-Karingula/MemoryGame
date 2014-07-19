//
//  MEMFlickrImageEntity.m
//  MemoryGame
//
//  Created by Administrator on 7/19/14.
//  Copyright (c) 2014 MEM. All rights reserved.
//

#import "MEMFlickrImageEntity.h"

@implementation MEMFlickrImageEntity
@synthesize uniqueId, name, locationUrl, hideImage;

+(id) objectWithDictionary:(NSDictionary*)dictionary
{
    id obj = [[MEMFlickrImageEntity alloc] initWithDictionary:dictionary];
    return obj;
}


-(id) initWithDictionary:(NSDictionary*)dictionary
{
    self = [super init];
    if(self)
    {
        
        /*
         {
         author = "nobody@flickr.com (canadafranchiseexpert)";
         "author_id" = "121851038@N03";
         "date_taken" = "2008-07-18T10:28:25-08:00";
         description = " <p><a href=\"http://www.flickr.com/people/121851038@N03/\">canadafranchiseexpert</a> posted a photo:</p> <p><a href=\"http://www.flickr.com/photos/121851038@N03/14505180539/\" title=\"Gary Prenevost:Finding Your Business - Proper Search Methodology\"><img src=\"http://farm3.staticflickr.com/2906/14505180539_6d246efa6e_m.jpg\" width=\"240\" height=\"159\" alt=\"Gary Prenevost:Finding Your Business - Proper Search Methodology\" /></a></p> <p>Looking for the right franchise business takes a significant amount of time and <br /> <br /> effort. Here is the proper search methodology to find your right business.For more <br /> <br /> information visit us @ <a href=\"http://canadafranchiseexpert.ca/finding-business-proper-\" rel=\"nofollow\">canadafranchiseexpert.ca/finding-business-proper-</a><br /> search-methodology/</p>";
         link = "http://www.flickr.com/photos/121851038@N03/14505180539/";
         media =     {
         m = "http://farm3.staticflickr.com/2906/14505180539_6d246efa6e_m.jpg";
         };
         published = "2014-07-19T16:29:09Z";
         tags = "new white chart businessman pen pencil writing flow sketch education hand empty plan meeting graph science whiteboard line teacher business seminar workshop blank diagram brainstorming learning data consultant teaching copyspace lecture pointing ideas showing studying flowchart lecturer academic tracing concepts organisation whitecollarworker";
         title = "Gary Prenevost:Finding Your Business - Proper Search Methodology";
         }
         
        identifiers = [[HSI_Clips_ClipIdentifiers alloc] initWithDictionary:[dictionary objectForKey:@"identifiers"]];
        NSArray *temprelation = [dictionary objectForKey:@"relation"];
        relation = [[NSMutableArray alloc] init];
        for(NSDictionary *d in temprelation)
        {
            [relation addObject:[HSI_Clips_ClipRelation objectWithDictionary:d]];
        }
        clipStartTime = [dictionary objectForKey:@"clipStartTime"];
        clipEndTime = [dictionary objectForKey:@"clipEndTime"];
        clipDuration = [dictionary objectForKey:@"clipDuration"];
        clipStatus = [dictionary objectForKey:@"clipStatus"] ;
        recordingType = [dictionary objectForKey:@"recordingType"];
        IsStoredOnRemoteLocation = [dictionary objectForKey:@"IsStoredOnRemoteLocation"];
        NSArray *tempsegments = [dictionary objectForKey:@"segments"];
        segments = [[NSMutableArray alloc] init];
        for(NSDictionary *d in tempsegments)
        {
            [segments addObject:[HSI_RecordingSegmentConfig objectWithDictionary:d]];
        }
        expand = [dictionary objectForKey:@"expand"];
        NSArray *extendArray = [dictionary objectForKey:@"extension"];
        extension =[[NSMutableDictionary alloc] init];
        for(NSDictionary *d in extendArray)
        {
            [extension setObject:d forKey:[d objectForKey:@"name"]];
        }
         */
        
    }
    return self;
}
@end
