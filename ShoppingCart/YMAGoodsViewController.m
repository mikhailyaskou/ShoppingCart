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

static NSString *const YMAGoodsCellIdentifier = @"YMAGoodsCell";

@interface YMAGoodsViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView * TableView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end

@implementation YMAGoodsViewController

+ (YMAGoodsViewController *)sharedInstance {
    static YMAGoodsViewController *_sharedInstance = nil;
    static dispatch_once_t oneTask;
    dispatch_once(&oneTask, ^{
        UIStoryboard *sb = [UIStoryboard  storyboardWithName: @"Main" bundle:nil];
        _sharedInstance = [sb instantiateViewControllerWithIdentifier:@"YMAGoodsViewController"];
    });
    return _sharedInstance;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //register nib in table view
    UINib *nib = [UINib nibWithNibName:@"YMAGoodsCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"YMAGoodsCell"];
    // set left menu
    YMALeftMenuViewController.sharedInstance.drawerTransition = [[PGDrawerTransition alloc] initWithTargetViewController:self.navigationController
                                                                                                    drawerViewController:YMALeftMenuViewController.sharedInstance];

    [YMABackEnd fetchPhoneWithCompletionHandler:^{
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"available == %@", @YES];
        self.fetchedResultsController =  [YMADataBase.sharedDataBase fetchedResultsControllerWithDataName:@"YMAGoods" predicate:predicate sotretByKey:@"name"];
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
    YMAGoods *product = (YMAGoods *) [self.fetchedResultsController objectAtIndexPath:indexPath];
    [YMAShopService.sharedShopService addToCart:product.objectID];
}

@end
