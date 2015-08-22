//
//  RSImageView.h
//  ConChat
//
//  Created by Rahul on 3/16/15.
//  Copyright (c) 2015 MaverickWorks. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface RSAsyncImageView : UIImageView

@property (nonatomic , assign) BOOL  borderNeeded;
@property (nonatomic , strong) UIColor* borderColor;

- (void)fetchImageFromURL:(NSURL*)imageURL withCache:(BOOL)cache;

@end