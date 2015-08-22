//
//  InstagramViewController.m
//  OutThereTesting
//
//  Created by DEV MODE on 8/21/15.
//  Copyright (c) 2015 DEV MODE. All rights reserved.
//

#import "InstagramViewController.h"

#define KAUTHURL @"https://api.instagram.com/oauth/authorize/"
#define kAPIURl @"https://api.instagram.com/v1/users/"
#define KCLIENTID @"7a6451bfb40f4ea8a00a7b664d77549e"
#define KCLIENTSERCRET @"058dc880da4e453aa6039ef257231c53"
#define kREDIRECTURI @"ig7a6451bfb40f4ea8a00a7b664d77549e://authorize"

@interface InstagramViewController ()

@property(nonatomic, strong) NSString *fullURL;

@end


@implementation InstagramViewController
@synthesize fullURL;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
       self.fullURL = [NSString stringWithFormat:@"%@%@&redirect_uri= %@&response_type=token",KAUTHURL,KCLIENTID,kREDIRECTURI];
}

-(void)loadURL{
    NSURL *url = [NSURL URLWithString:fullURL];
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url]; [mywebview loadRequest:requestObj];
    mywebview.delegate = self;
    [self.view addSubview:mywebview];
}

@end
