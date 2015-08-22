//
//  IGMediaResolution.h
//  OutThereTesting
//
//  Created by DEV MODE on 8/22/15.
//  Copyright (c) 2015 DEV MODE. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 "url":"https:\/\/scontent.cdninstagram.com\/hphotos-xaf1\/t51.2885-15\/s320x320\/e15\/11330773_758401677602460_1512561856_n.jpg",
 "width":320,
 "height":320
 */

//typedef NS_ENUM(NSInteger, IGMediaResolutionType) {
//    IGMediaResolutionTypeLow = 1,
//    IGMediaResolutionTypeStandard = 2,
//    IGMediaResolutionTypeThumbnail = 3,
//};

@interface IGMediaResolution : NSObject

//@property (nonatomic , assign) IGMediaResolutionType igmediaResType;
@property (nonatomic  ,strong) NSString* igmediaResURL;
@property (nonatomic  ,assign) float     igmediaResWidth;
@property (nonatomic  ,assign) float     igmediaResHeight;

- (instancetype)initWithJSONDictionary:(NSDictionary*)jsonDictionary;

- (double)totalResolution;
@end