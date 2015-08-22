//
//  RSImageView.m
//  ConChat
//
//  Created by Rahul on 3/16/15.
//  Copyright (c) 2015 MaverickWorks. All rights reserved.
//

#import "RSAsyncImageView.h"
#import "FTWCache.h"

@interface RSAsyncImageView()

@property (nonatomic , strong) UIActivityIndicatorView* activityIndicatorView;

@end

@implementation RSAsyncImageView

@synthesize activityIndicatorView;
@synthesize borderColor;
@synthesize borderNeeded;

- (void)awakeFromNib {
    self.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)fetchImageFromURL:(NSURL*)imageURL withCache:(BOOL)cache {
    NSData* imageData  = [FTWCache objectForKey:[imageURL lastPathComponent]];
    if (imageData && cache) {
        [self setImage:[UIImage imageWithData:imageData scale:[[UIScreen mainScreen] scale]]];
    }
    else {
        // There is no previous cache saved for this request so create one
        // add a loading icon before image is fetched
        if (!activityIndicatorView) {
            self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [self.activityIndicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self.activityIndicatorView setHidesWhenStopped:YES];
            [self addSubview:self.activityIndicatorView];
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[superView]-(<=1)-[activityIndicatorView]"
                                                                         options:NSLayoutFormatAlignAllCenterY
                                                                         metrics:nil
                                                                           views:@{@"activityIndicatorView" : activityIndicatorView,
                                                                                   @"superView" : self}]];
            
            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[superView]-(<=1)-[activityIndicatorView]"
                                                                         options:NSLayoutFormatAlignAllCenterX
                                                                         metrics:nil
                                                                           views:@{@"activityIndicatorView" : activityIndicatorView,
                                                                                   @"superView" : self}]];
            
            
        }
        [self.activityIndicatorView setCenter:self.center];
        [self.activityIndicatorView setHidden:NO];
        [self.activityIndicatorView startAnimating];
        
        RSAsyncImageView* __weak weakSelf = self;
        
        dispatch_queue_t queue = dispatch_queue_create("com.rsimageview.fetchqueue", DISPATCH_QUEUE_CONCURRENT);
        
        dispatch_async(queue, ^{
            
            NSData* imageRawData = [[NSData alloc] initWithContentsOfURL:imageURL];
            
            if (imageRawData) {
                if (cache) {
                    [FTWCache setObject:imageRawData forKey:[imageURL lastPathComponent]];
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf setImage:[[UIImage alloc] initWithData:imageRawData scale:[[UIScreen mainScreen] scale]]];
                    [[weakSelf activityIndicatorView] stopAnimating];
                });
            }
            else {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[weakSelf activityIndicatorView] stopAnimating];
                });
            }
        });
    }

}

@end