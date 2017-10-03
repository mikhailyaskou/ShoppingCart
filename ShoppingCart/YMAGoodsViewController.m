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
#import "YMABackEnd.h"
#import "YMANotAvailableGoodsCell.h"


static NSString *const YMAGoodsCellIdentifier = @"YMAGoodsCell";

@interface YMAGoodsViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) PGDrawerTransition *drawerTransition;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end

@implementation YMAGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //register nib in table view
    UINib *nib = [UINib nibWithNibName:@"YMAGoodsCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"YMAGoodsCell"];
    // set left menu
    self.drawerTransition = [[PGDrawerTransition alloc] initWithTargetViewController:self
                                                                drawerViewController:YMALeftMenuViewController.sharedInstance];
    [YMABackEnd fetchPhoneWithCompletionHandler:^{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"available == %@", @YES];
        self.fetchedResultsController =  [YMADataBase.sharedDataBase fetchedResultsControllerWithDataName:@"YMAGoods" predicate:predicate sotretByKey:@"name"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    
}

- (IBAction)menyTapped:(id)sender {
        [self.drawerTransition presentDrawerViewController];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo =
            self.fetchedResultsController.sections[section];

    return [sectionInfo numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMAGoods *goods = (YMAGoods *) [self.fetchedResultsController objectAtIndexPath:indexPath];
        YMAGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YMAGoodsCell"];
        cell.name.text = goods.name;
        cell.code.text = [NSString stringWithFormat:@"%d", goods.code];
        NSURL *url = [NSURL URLWithString:goods.image];
        NSData *data = [NSData dataWithContentsOfURL:url];
        cell.image.image = [[UIImage alloc] initWithData:data];
        cell.delegate = self;
        return cell;
}

- (void)touchedTheCell:(UIButton *)button {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *) button.superview.superview];
    NSLog(@"%ld", (long) indexPath.row);

    YMAGoods *product = (YMAGoods *) [self.fetchedResultsController objectAtIndexPath:indexPath];

    NSLog(@"%@", product.name);

    [[YMAShopService sharedShopService] addToCart:product];
}

@end
