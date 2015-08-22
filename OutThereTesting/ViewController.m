//
//  ViewController.m
//  OutThereTesting
//
//  Created by DEV MODE on 8/19/15.
//  Copyright (c) 2015 DEV MODE. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
    @property (nonatomic, strong) NSMutableData * responceData;
@end

@implementation ViewController
@synthesize responceData;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.searchBar.delegate = self;
    self.myMap.delegate = self;
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSLog(@"working");
    
    [self.searchBar resignFirstResponder];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder geocodeAddressString:self.searchBar.text completionHandler:^(NSArray *placemarks, NSError *error) {

        CLPlacemark *placemark = [placemarks objectAtIndex:0];
        MKCoordinateRegion region;
        CLLocationCoordinate2D newLocation = [placemark.location coordinate];
        region.center = [(CLCircularRegion *)placemark.region center];
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        [annotation setCoordinate:newLocation];


        NSLog(@"Lat of %@: %f",self.searchBar.text, newLocation.latitude);
        NSLog(@"Long of %@: %f",self.searchBar.text, newLocation.longitude);

        [self fetchNamedLocationFromInstagram:newLocation.latitude andLondgitude:newLocation.longitude];

        [annotation setTitle:self.searchBar.text];
        [self.myMap addAnnotation:annotation];
        
        MKMapRect mr = [self.myMap visibleMapRect];
        MKMapPoint pt = MKMapPointForCoordinate([annotation coordinate]);
        mr.origin.x = pt.x - mr.size.width * 0.5;
        mr.origin.y = pt.y -mr.size.width * 0.25;
        [self.myMap setVisibleMapRect:mr animated:YES];
    }];

    
}

#pragma mark - startInsagram

- (IBAction)searchButton:(id)sender {
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;

    appDelegate.instagram.accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"];

    appDelegate.instagram.sessionDelegate = self;

    if ([appDelegate.instagram isSessionValid] == NO) {
        [appDelegate.instagram authorize:nil]; // triggers the authenication process
    }
    else{

    }
}

-(void)igDidLogin{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:appDelegate.instagram.accessToken forKey:@"accessToken"];
    [userDefaults synchronize];
}

-(void)igDidNotLogin:(BOOL)cancelled{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void)igDidLogout{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void)igSessionInvalidated{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

#pragma mark - IGRequestDelegate Methods

- (void)fetchNamedLocationFromInstagram:(double)latitude andLondgitude:(double)longitude{

    self.responceData = [[NSMutableData alloc] init];

    AppDelegate* appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    Instagram* instagramObject  = [appDelegate instagram];

    NSDictionary* dictionaryForRequest =  [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithDouble:latitude], @"lat",
                                           [NSNumber numberWithDouble:longitude], @"lng",@"locations",@"method",nil];

    [instagramObject requestWithParams:[dictionaryForRequest mutableCopy] delegate:self];
}

- (void)requestLoading:(IGRequest *)request{

}

/**
 * Called when the server responds and begins to send back data.
 */
- (void)request:(IGRequest *)request didReceiveResponse:(NSURLResponse *)response{


}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(IGRequest *)request didFailWithError:(NSError *)error{

}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array, a string, or a number,
 * depending on thee format of the API response.
 */
- (void)request:(IGRequest *)request didLoad:(id)result{
    NSLog(@"%@", result );
}


@end