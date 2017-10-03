//
//  YMAOrdersViewController.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 02.08.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAOrdersViewController.h"
#import "YMAOrderTableViewCell.h"
#import <CoreData/CoreData.h>
#import "YMADataBase.h"
#import "YMADateHelper.h"
#import "YMAOrder+CoreDataClass.h"
#import "PGDrawerTransition.h"
#import "YMALeftMenuViewController.h"

@interface YMAOrdersViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) PGDrawerTransition *drawerTransition;


@end

@implementation YMAOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UINib *nib = [UINib nibWithNibName:@"YMAOrderTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"YMAOrderTableViewCell"];
    
    // set left menu
    self.drawerTransition = [[PGDrawerTransition alloc] initWithTargetViewController:self
                                                                drawerViewController:YMALeftMenuViewController.sharedInstance];

    //   [self initializeFetchedResultsController];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initializeFetchedResultsController];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}


- (void)initializeFetchedResultsController {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"YMAOrder"];

    NSSortDescriptor *lastNameSort = [NSSortDescriptor sortDescriptorWithKey:@"state" ascending:YES];

    [request setSortDescriptors:@[lastNameSort]];

    NSManagedObjectContext *moc = [[YMADataBase sharedDataBase] managedObjectContext];

    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil]];
    [[self fetchedResultsController] setDelegate:self];

    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}

- (IBAction)menuTapped:(id)sender {
    [self.drawerTransition presentDrawerViewController];
}


- (void)configureCell:(YMAOrderTableViewCell *)cell withObject:(YMAOrder *)order {
    cell.orderId.text = [NSString stringWithFormat:@"%d", order.orderId];
    cell.date.text = [YMADateHelper stringFromDate:order.date];
    cell.state.text = [NSString stringWithFormat:@"%d", order.state];

}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo =
            [[[self fetchedResultsController] sections] objectAtIndex:section];

    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    YMAOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YMAOrderTableViewCell"];
    YMAOrder *order = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self configureCell:cell withObject:order];
    return cell;


}


@end
