//
//  MasterViewController.m
//  Github Search
//
//  Created by Eric Chee on 12/23/14.
//  Copyright (c) 2014 Eric Chee. All rights reserved.
//

#import "MasterViewController.h"
#import "RepoDetailViewController.h"
#import "RepoTableViewCell.h"
#import "FilterBarView.h"

static NSString *RepoCellIdentifier = @"RepoCells";
static CGFloat const filterBarHeight = 50.0f;

@interface MasterViewController ()

@property NSMutableArray *objects;  // TODO: delete this
@property NSMutableArray *repositoryItems;
@property UIButton *searchButton;
@property UISearchBar *searchBar;
@property FilterBarView *filterBarView;

@end

@implementation MasterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Results";
    
    [self.tableView registerClass:[RepoTableViewCell class] forCellReuseIdentifier:RepoCellIdentifier];
    
    self.searchButton = [self createSearchButton];
    self.searchBar = [self createSearchBar];
    self.searchBar.delegate = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchButton];
    self.navigationItem.titleView = self.searchBar;
    
    self.detailViewController = (RepoDetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];

}

#pragma mark - Search

// Create Search button that accompanies the search bar
- (UIButton *)createSearchButton
{
    UIImage *iconImage = [UIImage imageNamed:@"searchIcon.png"];
    CGRect frameImg = CGRectMake(0.0f, 0.0f, 31.0f, 31.0f);
    
    UIButton *searchButton = [[UIButton alloc] initWithFrame:frameImg];
    [searchButton setBackgroundImage:iconImage forState:UIControlStateNormal];
    [searchButton addTarget:self
                     action:@selector(tappedSearchIcon:) forControlEvents:UIControlEventTouchUpInside];
    [searchButton setShowsTouchWhenHighlighted:YES];
    
    return searchButton;
}

// create search bar
- (UISearchBar *)createSearchBar
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0f,
                                                                          0.0f,
                                                                          self.navigationController.navigationBar.bounds.size.width - 90.0f,
                                                                           64.0f)];
    searchBar.placeholder = @"Search for GitHub Repository";
    return searchBar;
}

// Perform search if tapped Icon
- (void)tappedSearchIcon:(id)sender
{
    [self performSearch:self.searchBar.text];
}

// called when keyboard search button pressed
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self performSearch:searchBar.text];
}

// Make AFNetwork request with given query
- (void)performSearch:(NSString *)query
{
    if ([query length] > 0) {
        
        [self.searchBar resignFirstResponder];
        
        // send client parameters to fetch from API
        SearchHTTPClient *client = [SearchHTTPClient sharedSearchHTTPClient];
        client.delegate = self;
        [client searchReposWithName:query withLanguage:@""];
        
        [self showFilterBarView];
    }
}

#pragma mark - Filter Bar

// Show filter Cell at the top of the table
- (void)showFilterBarView
{
    
    CGRect filterBarRect = CGRectMake(0.0f,
                                      0.0f,
                                      self.view.bounds.size.width,
                                      filterBarHeight);
    FilterBarView *filterBarView = [[FilterBarView alloc] initWithFrame:filterBarRect];
    
    self.filterBarView = filterBarView;
    
    [self.view addSubview:self.filterBarView];
    
    [self.filterBarView.filterButton addTarget:self
                                        action:@selector(popupFilter:)
                              forControlEvents:UIControlEventTouchUpInside];
}

// Show Pop for user to input a language filter
- (void)popupFilter:(id)sender
{
    UIAlertView *filterAlert = [[UIAlertView alloc] initWithTitle:@"Add Filter"
                                                          message:@"What language do you want to filter by?"
                                                         delegate:self
                                                cancelButtonTitle:@"Cancel"
                                                otherButtonTitles:@"Filter", nil];
    [filterAlert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [filterAlert show];
}

// remove focus from search back to filter alert
- (void)didPresentAlertView:(UIAlertView *)alertView {
    UITextField *filterField = [alertView textFieldAtIndex:0];
    [filterField becomeFirstResponder];
}

// Filter results if user pressed "Filter" button
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:@"Filter"]) {
        NSString *repoNameQuery = self.searchBar.text;
        
        if ([repoNameQuery length] > 0) {
            
            UITextField *filterFeild = [alertView textFieldAtIndex:0];
            NSString *languageQuery = filterFeild.text;
            
            NSString *buttonTitle = [NSString stringWithFormat:@"Language = \"%@\" | Click to Change", languageQuery];
            
            if ([languageQuery length] <= 0) {
                buttonTitle = @"Add Language Filter";
            }
            
            [self.filterBarView.filterButton setTitle:buttonTitle forState:UIControlStateNormal];
            
            SearchHTTPClient *client = [SearchHTTPClient sharedSearchHTTPClient];
            client.delegate = self;
            [client searchReposWithName:repoNameQuery withLanguage:languageQuery];
        } else {
            
        }
    }
}

#pragma mark - Successful Callbacks

// Successfully Received results from Github Search API
-(void)searchHTTPClient:(SearchHTTPClient *)client gotResults:(id)results
{
    NSLog(@"Successfully received callback");
    
    
    if ([results isKindOfClass:[NSDictionary class]]) {
        
        NSLog(@"Number of items returned = %lu", [results[@"items"] count]);
        
        self.repositoryItems = results[@"items"];
        
        // insert cells
        [self.tableView reloadData];
        
    }
}

-(void)searchHTTPClient:(SearchHTTPClient *)client failedResults:(NSError *)error
{
        NSLog(@"error receiving call back = %@", error);
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSDictionary *repoData = self.repositoryItems[indexPath.row];
        
        RepoDetailViewController *controller = (RepoDetailViewController *)[[segue destinationViewController] topViewController];

        [controller setRepoDetails:repoData];
        
        controller.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
        controller.navigationItem.leftItemsSupplementBackButton = YES;
    }
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.repositoryItems count];
}

// Show repository name in each cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RepoTableViewCell *cell = (RepoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:RepoCellIdentifier forIndexPath:indexPath];
    
    NSString *name = self.repositoryItems[indexPath.row][@"name"];
    
    cell.repoLabel.text = name;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

// When a Cell is Tapped/Highlighted, Show Detailed View Controller
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tapped at %@", indexPath);
    
    [self performSegueWithIdentifier:@"showDetail" sender:nil];
    
    NSDictionary *repoData = self.repositoryItems[indexPath.row];
    [self.detailViewController setRepoDetails:repoData];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

@end
