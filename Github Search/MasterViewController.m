//
//  MasterViewController.m
//  Github Search
//
//  Created by Eric Chee on 12/23/14.
//  Copyright (c) 2014 Eric Chee. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "RepoTableViewCell.h"

static NSString *RepoCellIdentifier = @"RepoCells";

@interface MasterViewController ()

@property NSMutableArray *objects;  // TODO: delete this
@property NSMutableArray *repositoryItems;

@end

@implementation MasterViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"Results";
    
    [self.tableView registerClass:[RepoTableViewCell class] forCellReuseIdentifier:RepoCellIdentifier];
    
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;
//
//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    // send client parameters to fetch from API
    SearchHTTPClient *client = [SearchHTTPClient sharedSearchHTTPClient];
    client.delegate = self;
    [client searchReposWithName:@"tetris" withLanguage:@"assembly"];    // TODO: allow searching
}

// Successfully Received results from Github Search API
-(void)searchHTTPClient:(SearchHTTPClient *)client gotResults:(id)results
{
    NSLog(@"Successfully received callback");
    
    // TODO: DELETE THIS - shows response back
    // NSLog(@"%@", results);
    
    if ([results isKindOfClass:[NSDictionary class]]) {
        
        // TODO: DELETE THIS - shows items
        NSLog(@"Result items = %@", results[@"items"]);
        
        NSLog(@"Number of items = %lu", [results[@"items"] count]);
        
        self.repositoryItems = results[@"items"];
        
        // insert cells
        [self.tableView reloadData];
        
    }
}

-(void)searchHTTPClient:(SearchHTTPClient *)client failedResults:(NSError *)error
{
        NSLog(@"%@", error);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender {
    if (!self.objects) {
        self.objects = [[NSMutableArray alloc] init];
    }
    [self.objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSDictionary *repoData = self.repositoryItems[indexPath.row];
        
        DetailViewController *controller = (DetailViewController *)[[segue destinationViewController] topViewController];

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RepoTableViewCell *cell = (RepoTableViewCell *)[tableView dequeueReusableCellWithIdentifier:RepoCellIdentifier forIndexPath:indexPath];
    
    NSString *name = self.repositoryItems[indexPath.row][@"name"];
    
    cell.repoLabel.text = name;
    
//    NSDate *object = self.objects[indexPath.row];
//    cell.textLabel.text = [object description];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

// When a Cell is Tapped/Highlighted
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"tapped at %@", indexPath);
    
    [self performSegueWithIdentifier:@"showDetail" sender:nil];
    
    NSDictionary *repoData = self.repositoryItems[indexPath.row];
    [self.detailViewController setRepoDetails:repoData];

}

@end
