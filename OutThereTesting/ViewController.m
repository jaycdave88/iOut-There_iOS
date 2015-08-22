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

@end

@implementation ViewController

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


@end