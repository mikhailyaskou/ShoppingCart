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
#import "YMAGoodsCell.h"
#import "YMAConstants.h"

static NSString *const YMAGoodsCellNibName = @"YMAGoodsCell";
static NSString *const YMAGoodsViewControllerIdentifier = @"YMAGoodsViewController";

@interface YMAGoodsViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate, YMAProductCellDelegate>

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end

@implementation YMAGoodsViewController

+ (YMAGoodsViewController *)sharedInstance {
    static YMAGoodsViewController *_sharedInstance = nil;
    static dispatch_once_t oneTask;
    dispatch_once(&oneTask, ^{
        UIStoryboard *sb = [UIStoryboard storyboardWithName:YMAStoryboardName bundle:nil];
        _sharedInstance = [sb instantiateViewControllerWithIdentifier:YMAGoodsViewControllerIdentifier];
    });
    return _sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //register nib in table view
    UINib *nib = [UINib nibWithNibName:YMAGoodsCellNibName bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:YMAGoodsCellNibName];
    // set left menu
    YMALeftMenuViewController.sharedInstance.drawerTransition = [[PGDrawerTransition alloc] initWithTargetViewController:self.navigationController
                                                                                                    drawerViewController:YMALeftMenuViewController.sharedInstance];

    [YMABackEnd fetchPhoneWithCompletionHandler:^{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"available == %@", @YES];
        self.fetchedResultsController = [YMADataBase.sharedDataBase fetchedResultsControllerWithDataName:YMAGoodsEntitiesName predicate:predicate sotretByKey:@"name"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        [YMABackEnd fetchOrdersWithCompletionHandler:nil];
    }];
}

- (IBAction)menuTapped:(id)sender {
    [YMALeftMenuViewController.sharedInstance.drawerTransition presentDrawerViewController];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchedResultsController.sections[section].numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMAGoods *goods = (YMAGoods *) [self.fetchedResultsController objectAtIndexPath:indexPath];
    YMAGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:YMAGoodsCellNibName];
    cell.nameLabel.text = goods.name;
    cell.codeLabel.text = [NSString stringWithFormat:@"%d", goods.code];
    cell.price.text = [NSString stringWithFormat:@"%g", goods.price];
    NSURL *url = [NSURL URLWithString:goods.image];
    NSData *data = [NSData dataWithContentsOfURL:url];
    cell.image.image = [[UIImage alloc] initWithData:data];
    cell.delegate = self;
    return cell;
}

#pragma mark - YMACartCell Delegate

- (void)cellButtonTapped:(UIButton *)button {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell *) button.superview.superview];
    YMAGoods *product = (YMAGoods *) [self.fetchedResultsController objectAtIndexPath:indexPath];
    [YMAShopService.sharedShopService addToCart:product.objectID];
}

@end
