//
//  DetailViewController.h
//  Github Search
//
//  Created by Eric Chee on 12/23/14.
//  Copyright (c) 2014 Eric Chee. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>

@interface RepoDetailViewController : UIViewController

@property (nonatomic, strong) NSDictionary *repoDetails;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

