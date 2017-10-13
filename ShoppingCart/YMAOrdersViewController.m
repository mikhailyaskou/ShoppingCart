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
#import "YMAShopService.h"
#import "YMAConstants.h"

static NSString *const YMAOrderTableViewCellNibName = @"YMAOrderTableViewCell";

@interface YMAOrdersViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end

@implementation YMAOrdersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:YMAOrderTableViewCellNibName bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:YMAOrderTableViewCellNibName];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.fetchedResultsController = [YMADataBase.sharedDataBase fetchedResultsControllerWithDataName:YMAOrderEntityName predicate:nil sotretByKey:@"date"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.fetchedResultsController setDelegate:self];
    });
}

- (IBAction)showMenuTapped:(id)sender {
    [YMALeftMenuViewController.sharedInstance.drawerTransition presentDrawerViewController];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchedResultsController.sections[section].numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMAOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:YMAOrderTableViewCellNibName];
    YMAOrder *order = (YMAOrder *) [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.orderId.text = [NSString stringWithFormat:@"%hi", order.orderId];
    cell.date.text = [YMADateHelper stringFromDate:order.date];
    cell.state.text = [NSString stringWithFormat:@"%hi", order.state];
    cell.price.text = ([YMAShopService.sharedShopService totalOrderPrice:order]).stringValue;
    return cell;
}

@end