//
//  YMAGoodsViewController.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 18.07.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAGoodsViewController.h"
#import "YMADataBase.h"
#import "YMAShopService.h"
#import "YMAGoods+CoreDataProperties.h"
#import "PGDrawerTransition.h"
#import "YMALeftMenuViewController.h"


static NSString *const YMAGoodsCellIdentifier = @"YMAGoodsCell";

@interface YMAGoodsViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) PGDrawerTransition *drawerTransition;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end

@implementation YMAGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //register nib in teble view
    UINib *nib = [UINib nibWithNibName:@"YMAGoodsCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"YMAGoodsCell"];
    // set left menu
    self.drawerTransition = [[PGDrawerTransition alloc] initWithTargetViewController:self
                                                                drawerViewController:YMALeftMenuViewController.sharedInstance];
    
}


- (void)viewWillAppear:(BOOL)animated {
    [self initializeFetchedResultsController];
}

- (IBAction)menyTapped:(id)sender {
        [self.drawerTransition presentDrawerViewController];
}

//get all goods;
- (void)initializeFetchedResultsController {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"YMAGoods"];

    NSSortDescriptor *lastNameSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo =
            [[[self fetchedResultsController] sections] objectAtIndex:section];

    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    YMAGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YMAGoodsCell"];
    YMAGoods *goods = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.name.text = goods.name;
    cell.code.text = [NSString stringWithFormat:@"%d", goods.code];
    cell.price.text = [NSString stringWithFormat:@"%f", goods.price];

    cell.delegate = self;

    return cell;
}

- (void)touchedTheCell:(UIButton *)button {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *) button.superview.superview];
    NSLog(@"%ld", (long) indexPath.row);

    YMAGoods *product = [self.fetchedResultsController objectAtIndexPath:indexPath];

    NSLog(@"%@", product.name);

    [[YMAShopService sharedShopService] addToCart:product];
}

@end
