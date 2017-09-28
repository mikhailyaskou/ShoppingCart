//
//  YMAGoodsViewController.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 18.07.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAGoodsViewController.h"
#import "YMABackEnd.h"
#import "YMADataBase.h"
#import "YMAGoodsCell.h"
#import <CoreData/CoreData.h>
#import "Goods+CoreDataClass.h"
#import "YMAShopService.h"

static NSString *const YMAGoodsCellIdentifier = @"YMAGoodsCell";

@interface YMAGoodsViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,retain)NSFetchedResultsController *fetchedResultsController;

@end

@implementation YMAGoodsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"YMAGoodsCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"YMAGoodsCell"];
    
    
}


-(void)viewWillAppear:(BOOL)animated {
    [self initializeFetchedResultsController];
}

//get all goods;
- (void)initializeFetchedResultsController
{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Goods"];
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo =
    [[[self fetchedResultsController] sections] objectAtIndex:section];
    
    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YMAGoodsCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"YMAGoodsCell"];
    Goods *goods = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.name.text = goods.name;
    cell.code.text = [NSString stringWithFormat:@"%d", goods.code];
    cell.price.text = [NSString stringWithFormat:@"%f", goods.price];
    
    cell.delegate = self;
    
    return cell;
}

- (void)touchedTheCell:(UIButton *)button
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *)button.superview.superview];
    NSLog(@"%ld",(long)indexPath.row);
    
    Goods *product = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    NSLog(@"%@", product.name);
    
    [[YMAShopService sharedShopService] addToCart:product];
}

@end
