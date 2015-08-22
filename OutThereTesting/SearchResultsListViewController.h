//
//  SearchResultsListViewController.h
//  OutThereTesting
//
//  Created by DEV MODE on 8/22/15.
//  Copyright (c) 2015 DEV MODE. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultsListViewController : UIViewController

@property (nonatomic , weak) IBOutlet UITableView* tblvSearchResults;

- (void)updateSearchResults:(NSArray*)results;
@end