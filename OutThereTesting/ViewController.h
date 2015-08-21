//
//  ViewController.h
//  OutThereTesting
//
//  Created by DEV MODE on 8/19/15.
//  Copyright (c) 2015 DEV MODE. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface ViewController : UIViewController <UISearchBarDelegate,MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@property (strong, nonatomic) IBOutlet MKMapView *myMap;

extern NSInteger latitude;
extern NSInteger longitude;

@end
