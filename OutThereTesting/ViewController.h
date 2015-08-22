//
//  ViewController.h
//  OutThereTesting
//
//  Created by DEV MODE on 8/19/15.
//  Copyright (c) 2015 DEV MODE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Instagram.h"

@interface ViewController : UIViewController <UISearchBarDelegate,MKMapViewDelegate,IGSessionDelegate,IGRequestDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet MKMapView *myMap;

- (IBAction)searchButton:(id)sender;

extern NSInteger latitude;
extern NSInteger longitude;

@end

