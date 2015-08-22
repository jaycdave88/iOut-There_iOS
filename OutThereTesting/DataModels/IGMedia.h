//
//  IGMedia.h
//  OutThereTesting
//
//  Created by DEV MODE on 8/22/15.
//  Copyright (c) 2015 DEV MODE. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IGMediaResolution;

@interface IGMedia : NSObject

@property (nonatomic , strong) NSString* igMediaId;
@property (nonatomic , strong) NSString* igMediaCreatedTime;
@property (nonatomic , strong) NSString* igMediaURL;
@property (nonatomic , assign) BOOL      igMediaIsLikedByUser;

//@property (nonatomic , strong) NSArray*  igMediaResolutionTypes;

@property (nonatomic , strong) IGMediaResolution* igMediaResolutionStandard;
@property (nonatomic , strong) IGMediaResolution* igMediaResolutionThumbnail;
@property (nonatomic , strong) IGMediaResolution* igMediaResolutionLow;

- (instancetype)initWithJSONDictionary:(NSDictionary*)jsonDictionary;


@end
