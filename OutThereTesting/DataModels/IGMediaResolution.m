//
//  IGMediaResolution.m
//  OutThereTesting
//
//  Created by DEV MODE on 8/22/15.
//  Copyright (c) 2015 DEV MODE. All rights reserved.
//

#import "IGMediaResolution.h"

@implementation IGMediaResolution

@synthesize igmediaResURL;
@synthesize igmediaResWidth;
@synthesize igmediaResHeight;

- (instancetype)initWithJSONDictionary:(NSDictionary*)jsonDictionary {
    if (self = [super init]) {
        self.igmediaResURL = [jsonDictionary valueForKey:@"url"];
        self.igmediaResWidth = [[jsonDictionary valueForKey:@"width"] floatValue];
        self.igmediaResHeight = [[jsonDictionary valueForKey:@"height"] floatValue];
    }
    return self;
}

- (double)totalResolution {
    return igmediaResHeight * igmediaResWidth;
}
@end