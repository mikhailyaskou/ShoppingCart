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
#import "YMAGoods+CoreDataClass.h"
#import "YMAOrderBook+CoreDataProperties.h"

@interface YMAOrdersViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end

@implementation YMAOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UINib *nib = [UINib nibWithNibName:@"YMAOrderTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"YMAOrderTableViewCell"];
    

       [self initializeFetchedResultsController];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initializeFetchedResultsController];
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
}

- (IBAction)showMenuTapped:(id)sender {
    [YMALeftMenuViewController.sharedInstance.drawerTransition presentDrawerViewController];
    
}


- (void)initializeFetchedResultsController {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"YMAOrder"];

    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"state" ascending:YES];

    [request setSortDescriptors:@[sortDescriptor]];

    NSManagedObjectContext *moc = [[YMADataBase sharedDataBase] managedObjectContext];

    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil]];
    [[self fetchedResultsController] setDelegate:self];

    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}

- (void)configureCell:(YMAOrderTableViewCell *)cell withObject:(YMAOrder *)order {


}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo =
            self.fetchedResultsController.sections[section];

    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    YMAOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YMAOrderTableViewCell"];

    YMAOrder *order = (YMAOrder *) [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.orderId.text = [NSString stringWithFormat:@"%hi",order.orderId];
    cell.date.text = [YMADateHelper stringFromDate:order.date];
    cell.state.text = [NSString stringWithFormat:@"%hi", order.state];
    NSArray <YMAOrderBook *> *books = order.bookOrders.allObjects;

    NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!%lf",books.firstObject.goods.price);
   // cell.price.text = [books valueForKeyPath:@"@sum.goods.price"];
    return cell;


}


@end
