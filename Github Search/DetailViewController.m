//
//  DetailViewController.m
//  Github Search
//
//  Created by Eric Chee on 12/23/14.
//  Copyright (c) 2014 Eric Chee. All rights reserved.
//

#import "DetailViewController.h"
#import "RepoDetailsView.h"


@interface DetailViewController ()
@property (nonatomic, strong) RepoDetailsView *view;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

// If set Repo details, update view
- (void)setRepoDetails:(NSDictionary *)repoDetails {
    if (_repoDetails != repoDetails) {
        _repoDetails = repoDetails;
        
        [self configureRepoDetailView];
    }
}

- (void)configureRepoDetailView
{
    if (self.repoDetails) {
        self.title = self.repoDetails[@"name"];
        
        self.view = [[RepoDetailsView alloc] initWithFrame:self.view.bounds];
        
        [self fetchImage];
        [self insertDetails];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Don't hide under navBar
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self configureRepoDetailView];
    
}

- (void)fetchImage {
    NSString *imageOfOwnerURL = self.repoDetails[@"owner"][@"avatar_url"];
    
    if ([imageOfOwnerURL length] > 0){
        
        NSURL *url = [NSURL URLWithString:imageOfOwnerURL];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFImageResponseSerializer serializer];
        
        // fetch IMG, set as background image & save it as "background.png"
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self.view initOwnerImageViewWithImage:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error : %@", error);
        }];
        
        [operation start];

    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertDetails
{
    self.view.ownerLabel.text = [NSString stringWithFormat:@"Owner - %@", self.repoDetails[@"owner"][@"login"]];
}

@end
