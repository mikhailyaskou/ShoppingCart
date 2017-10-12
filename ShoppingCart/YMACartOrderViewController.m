//
//  YMACartOrderViewController.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 01.08.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import <PGDrawerTransition/PGDrawerTransition.h>
#import "YMACartOrderViewController.h"
#import "YMADataBase.h"
#import "YMAShopService.h"
#import "YMABackEnd.h"
#import "YMAGoods+CoreDataProperties.h"
#import "YMAOrderBook+CoreDataProperties.h"
#import "YMAAvailableGoodsCell.h"
#import "YMALeftMenuViewController.h"
#import "YMANotAvailableGoodsCell.h"

@interface YMACartOrderViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UIButton *sendOrderButton;

@end

@implementation YMACartOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UINib *nib = [UINib nibWithNibName:@"YMAAvailableGoodsCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"YMAAvailableGoodsCell"];
    nib = [UINib nibWithNibName:@"YMANotAvailableGoodsCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"YMANotAvailableGoodsCell"];
}

- (void)viewWillAppear:(BOOL)animated {
    [self initCartFetchedResultsController];
}

- (void)initCartFetchedResultsController {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"order.state == %@", @"0"];
    self.fetchedResultsController =  [YMADataBase.sharedDataBase fetchedResultsControllerWithDataName:@"YMAOrderBook" predicate:predicate sotretByKey:@"goods"];
        [self.tableView reloadData];
        [self.fetchedResultsController setDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated {
    if (!self.navigationController.navigationBar.backItem) {
        UIBarButtonItem *menuItem = [UIBarButtonItem new];
        menuItem.image = [UIImage imageNamed:@"icon_menu"];
        menuItem.target = self;
        menuItem.action = @selector(showMenuTapped:);
        self.navigationItem.leftBarButtonItem = menuItem;
    }
}

- (IBAction)showMenuTapped:(id)sender {
    [YMALeftMenuViewController.sharedInstance.drawerTransition presentDrawerViewController];
    [self initCartFetchedResultsController];
}

- (IBAction)sendOrderButtonTapped:(id)sender {
    if (self.fetchedResultsController.sections[0].numberOfObjects > 0) {
    [YMAShopService.sharedShopService sendCurrentOrder];
    [self.tableView reloadData];
    }
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {

    UITableView *tableView = self.tableView;

    switch(type) {

        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            break;

        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    [YMADataBase.sharedDataBase deleteObjectAndSave:[self.fetchedResultsController objectAtIndexPath:indexPath]];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [self.tableView setEditing: editing animated: animated];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.fetchedResultsController.sections[section].numberOfObjects;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMAOrderBook *orderBook = (YMAOrderBook *) [self.fetchedResultsController objectAtIndexPath:indexPath];
    YMAGoods *goods = orderBook.goods;

    
    if (goods.available  > 0) {
    YMAAvailableGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YMAAvailableGoodsCell"];
    
    cell.nameLabel.text = goods.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"%d", goods.code];
    cell.priceLabel.text = [NSString stringWithFormat:@"%.f", goods.price];
    cell.image.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:goods.image]]];
        return cell;
    }
    else {
        YMANotAvailableGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YMANotAvailableGoodsCell"];
        
        cell.nameLabel.text = goods.name;
        
        cell.image.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:goods.image]]];
        return cell;
    }
        
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [YMADataBase.sharedDataBase deleteObjectAndSave:[self.fetchedResultsController objectAtIndexPath:indexPath]];
    }
}

@end
