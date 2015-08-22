//
//  IGMedia.m
//  OutThereTesting
//
//  Created by DEV MODE on 8/22/15.
//  Copyright (c) 2015 DEV MODE. All rights reserved.
//

#import "IGMedia.h"

#import "IGMediaResolution.h"

@implementation IGMedia

@synthesize igMediaId;
@synthesize igMediaCreatedTime;
@synthesize igMediaURL;
@synthesize igMediaIsLikedByUser;

- (instancetype)initWithJSONDictionary:(NSDictionary*)jsonDictionary {
    if(self = [super init] ) {

        self.igMediaIsLikedByUser = [[jsonDictionary valueForKey:@"user_has_liked"] boolValue];
        self.igMediaId = [jsonDictionary valueForKey:@"id"];
        self.igMediaCreatedTime = [jsonDictionary valueForKey:@"created_time"];
        self.igMediaURL = [jsonDictionary valueForKey:@"link"];


        NSDictionary* dataForImages = [jsonDictionary valueForKey:@"images"];

        NSDictionary* lowResolutionImage = [dataForImages valueForKey:@"low_resolution"];
        NSDictionary* standardResolutionImage = [dataForImages valueForKey:@"standard_resolution"];
        NSDictionary* thumbnailResolutionImage = [dataForImages valueForKey:@"thumbnail"];

        self.igMediaResolutionLow = [[IGMediaResolution alloc] initWithJSONDictionary:lowResolutionImage];
        self.igMediaResolutionStandard = [[IGMediaResolution alloc] initWithJSONDictionary:standardResolutionImage];
        self.igMediaResolutionThumbnail = [[IGMediaResolution alloc] initWithJSONDictionary:thumbnailResolutionImage];


        
    }
    return self;
}
@end
