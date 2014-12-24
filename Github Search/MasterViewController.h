//
//  MasterViewController.h
//  Github Search
//
//  Created by Eric Chee on 12/23/14.
//  Copyright (c) 2014 Eric Chee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchHTTPClient.h"

@class RepoDetailViewController;

@interface MasterViewController : UITableViewController <SearchHTTPClientDelegate, UITableViewDelegate, UISearchBarDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) RepoDetailViewController *detailViewController;

@end

