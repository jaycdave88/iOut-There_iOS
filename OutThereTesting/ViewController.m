//
//  ViewController.m
//  OutThereTesting
//
//  Created by DEV MODE on 8/19/15.
//  Copyright (c) 2015 DEV MODE. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

// Data Model Classes
#import "IGMedia.h"
#import "IGMediaResolution.h"

#import "SearchResultsListViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSMutableArray* arrmSearchResults;

@end

@implementation ViewController

@synthesize arrmSearchResults;
@synthesize searchBarGeoLocation;
@synthesize mapViewInstagramPins;

#pragma mark - View Life Cycle Methods

- (void)viewDidLoad {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [super viewDidLoad];

    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    Instagram* instagramObject  = [appDelegate instagram];
    NSString* accessToken = [[NSUserDefaults standardUserDefaults] valueForKey:@"accessToken"];
    [instagramObject setAccessToken:accessToken];

    self.title = NSLocalizedString(@"STR_APPLICATION_TITLE", nil);
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [super viewWillAppear:animated];
    self.searchBarGeoLocation.delegate = self;
    self.mapViewInstagramPins.delegate = self;
}

- (void)viewDidLayoutSubviews {
    [self beautify];
}

- (void)viewWillDisappear:(BOOL)animated {
    NSLog(@"%s",__PRETTY_FUNCTION__);
    [super viewWillDisappear:animated];
    self.searchBarGeoLocation.delegate = nil;
    self.mapViewInstagramPins.delegate = nil;
}

#pragma mark - Search Bar Delegate Methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"working");
    
    [self.searchBarGeoLocation resignFirstResponder];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:self.searchBarGeoLocation.text completionHandler:^(NSArray *placemarks, NSError *error) {

        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        MKCoordinateRegion region;
        CLLocationCoordinate2D newLocation = [placemark.location coordinate];
        region.center = [(CLCircularRegion *)placemark.region center];
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:newLocation];


        NSLog(@"Lat of %@: %f",self.searchBarGeoLocation.text, newLocation.latitude);
        NSLog(@"Long of %@: %f",self.searchBarGeoLocation.text, newLocation.longitude);

        [self fetchNamedLocationFromInstagram:newLocation.latitude andLondgitude:newLocation.longitude];

        [annotation setTitle:self.searchBarGeoLocation.text];
        [self.mapViewInstagramPins addAnnotation:annotation];
        
        MKMapRect mr = [self.mapViewInstagramPins visibleMapRect];
        MKMapPoint pt = MKMapPointForCoordinate([annotation coordinate]);
        
        mr.origin.x = pt.x - mr.size.width * 0.5;
        mr.origin.y = pt.y -mr.size.width * 0.25;

        [self.mapViewInstagramPins setVisibleMapRect:mr animated:YES];
    }];

    
}

#pragma mark - IBAction Methods

- (IBAction)searchButton:(id)sender {
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    appDelegate.instagram.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];

    appDelegate.instagram.sessionDelegate = self;

    if ([appDelegate.instagram isSessionValid]  == YES && ([self.arrmSearchResults count] > 0 ) ) {
        SearchResultsListViewController* objVC = [self.storyboard instantiateViewControllerWithIdentifier:@"kSceneSearchResultsListViewController"];
        [objVC updateSearchResults:[self.arrmSearchResults copy]];
        [self.navigationController pushViewController:objVC animated:YES];
    }
    else {
        // Launch for Authorization
        [appDelegate.instagram authorize:nil]; // triggers the authenication process
    }
}

#pragma mark - Instagram Login Methods

- (void)igDidLogin{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:appDelegate.instagram.accessToken forKey:@"accessToken"];
    [userDefaults synchronize];
}

- (void)igDidNotLogin:(BOOL)cancelled{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)igDidLogout{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)igSessionInvalidated{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - User Defined Methods

- (void)beautify {
    CGFloat width = CGRectGetWidth(mapViewInstagramPins.frame);
    CGFloat height = CGRectGetHeight(mapViewInstagramPins.frame);
    CGFloat cornerRadiusFactor =  (width > height ? height/2 : width/2);

    [[mapViewInstagramPins layer] setCornerRadius:cornerRadiusFactor];
    [[mapViewInstagramPins layer] setMasksToBounds:YES];


}

- (void)fetchNamedLocationFromInstagram:(double)latitude andLondgitude:(double)longitude{


    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    Instagram* instagramObject  = [appDelegate instagram];

    // Search URL goes here

    //https://api.instagram.com/v1/media/search?lat= 0.00&lng=0.00&access_token=0.00&callback=?


    NSDictionary* dictionaryForRequest =  [NSDictionary dictionaryWithObjectsAndKeys:
                                           [NSString stringWithFormat:@"%.2f",latitude], @"lat",
                                           [NSString stringWithFormat:@"%.2f",longitude],@"lng",
                                           @"search",@"method",nil];

    [instagramObject requestWithParams:[dictionaryForRequest mutableCopy] delegate:self];
}

#pragma mark - IGRequestDelegate Methods

- (void)requestLoading:(IGRequest *)request{

}

- (void)request:(IGRequest *)request didReceiveResponse:(NSURLResponse *)response{


}

- (void)request:(IGRequest *)request didFailWithError:(NSError *)error{

}

- (void)request:(IGRequest *)request didLoad:(id)result{

//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:result options:NSJSONWritingPrettyPrinted error:nil];
//    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", jsonString );

#ifdef DEBUG
    NSLog(@"%s ",__PRETTY_FUNCTION__);
#endif
    if (arrmSearchResults == nil) {
        self.arrmSearchResults = [[NSMutableArray alloc] init];
    }

    [self.arrmSearchResults removeAllObjects];

    if ([result isKindOfClass:[NSDictionary class]]) {
        // Pull out the Object for the key @c data
        NSArray* arrResults  =  [result valueForKey:@"data"];
        for (NSDictionary* object in arrResults) {
            // Every Object is a node here
            IGMedia *myObject = [[IGMedia alloc] initWithJSONDictionary:object];
            [self.arrmSearchResults addObject:myObject];
        }
    }
    else if ([result isKindOfClass:[NSArray class]]) {

    }
    else {
        // Dead end
    }
    NSLog(@"Number of Search Results %ld" , [self.arrmSearchResults count]);

    for (IGMedia* media in arrmSearchResults) {
        IGMediaResolution* standardResolution = [media igMediaResolutionStandard];
        NSLog(@"URL is %@", [standardResolution igmediaResURL]);
    }
}


@end