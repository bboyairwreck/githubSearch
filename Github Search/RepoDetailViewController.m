//
//  DetailViewController.m
//  Github Search
//
//  Created by Eric Chee on 12/23/14.
//  Copyright (c) 2014 Eric Chee. All rights reserved.
//

#import "RepoDetailViewController.h"
#import "RepoDetailView.h"


@interface RepoDetailViewController ()
@property (nonatomic, strong) RepoDetailView *view;
@end

@implementation RepoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Don't hide under navBar
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    [self configureRepoDetailView];
    
}

#pragma mark - Managing the repo details

// If set Repository details, update view
- (void)setRepoDetails:(NSDictionary *)repoDetails {
    if (_repoDetails != repoDetails) {
        _repoDetails = repoDetails;
        
        [self configureRepoDetailView];
    }
}

// Update view with title, image, and insert detail labels
- (void)configureRepoDetailView
{
    if (self.repoDetails) {
        self.title = self.repoDetails[@"name"];
        
        self.view = [[RepoDetailView alloc] initWithFrame:self.view.bounds];
        
        [self fetchImage];
        [self insertDetails];
    }
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

// Takes data from repo details and inserts them into labels in the details view
- (void)insertDetails
{
    // [NSString stringWithFormat:@" - %@", self.repoDetails[@""][@""]];
    self.view.ownerLabel.text = [NSString stringWithFormat:@"Owner - %@", self.repoDetails[@"owner"][@"login"]];
    self.view.repoURL.text = [NSString stringWithFormat:@"Repository URL - %@", self.repoDetails[@"html_url"]];
    self.view.numOfStars.text = [NSString stringWithFormat:@"Number of Stars - %@", self.repoDetails[@"stargazers_count"]];
    self.view.canForkLabel.text = [NSString stringWithFormat:@"Forks - %@", self.repoDetails[@"forks_count"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
