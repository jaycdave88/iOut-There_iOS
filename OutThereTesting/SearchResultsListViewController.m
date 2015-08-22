//
//  SearchResultsListViewController.m
//  OutThereTesting
//
//  Created by DEV MODE on 8/22/15.
//  Copyright (c) 2015 DEV MODE. All rights reserved.
//

#import "SearchResultsListViewController.h"

#import "IGMedia.h"
#import "IGMediaResolution.h"
#import "RSAsyncImageView.h"
#import "FTWCache.h"


static NSString* const reuseIdentifier = @"SearchResultCell";

@interface SearchResultsListViewController ()

@property (nonatomic  ,strong) NSArray* arrSearchResults;
@end

@implementation SearchResultsListViewController

@synthesize arrSearchResults;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

/**
 @description User Defined Method to set and update the search results
 each index contains object of type @c IGMedia which have nested property
 containing of type @c IGMediaResoultion that contains URL for the image
 @param results @c NSArray
 */
- (void)updateSearchResults:(NSArray*)results {
    if (results != nil) {
        self.arrSearchResults = results;
        [self.tblvSearchResults reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return arrSearchResults.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier    forIndexPath:indexPath];
    
    // Configure the cell...
    IGMedia* media =  [self.arrSearchResults objectAtIndex:indexPath.row];
    IGMediaResolution* standardResolution = [media igMediaResolutionStandard];

    RSAsyncImageView* imageView = (RSAsyncImageView*)[cell viewWithTag:111];
    [imageView setBorderNeeded:YES];
    [imageView fetchImageFromURL:[NSURL URLWithString:standardResolution.igmediaResURL] withCache:YES];
    return cell;
}

//- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return 300;
//}

@end