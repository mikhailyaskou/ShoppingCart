//
//  YMACartOrderViewController.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 01.08.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMACartOrderViewController.h"
#import "YMADataBase.h"
#import "YMAShopService.h"
#import "YMAGoodsCell.h"
#import "YMAPrettyButtonHelper.h"
#import "YMABackEnd.h"
#import "YMAGoods+CoreDataProperties.h"
#import "YMAOrderBook+CoreDataProperties.h"

@interface YMACartOrderViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UIButton *sendOrderButton;

@end

@implementation YMACartOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UINib *nib = [UINib nibWithNibName:@"YMAGoodsCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"YMAGoodsCell"];
    [YMAPrettyButtonHelper makePrettyButton:self.sendOrderButton];

    [self initializeFetchedResultsController];
}


- (IBAction)sendOrderButtonTapped:(id)sender {
    YMAOrder *order = [[YMAShopService sharedShopService] currentOrder];
    [YMABackEnd post:order];
}


- (void)initializeFetchedResultsController {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"YMAOrderBook"];
    NSSortDescriptor *lastNameSort = [NSSortDescriptor sortDescriptorWithKey:@"goods" ascending:YES];
    [request setSortDescriptors:@[lastNameSort]];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"order.state == %@", @"0"];
    request.predicate = predicate;
    NSManagedObjectContext *moc = [[YMADataBase sharedDataBase] managedObjectContext];
    [self setFetchedResultsController:[[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:moc sectionNameKeyPath:nil cacheName:nil]];
    [[self fetchedResultsController] setDelegate:self];
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        NSLog(@"Failed to initialize FetchedResultsController: %@\n%@", [error localizedDescription], [error userInfo]);
        abort();
    }
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:animated];
}

- (void)configureCell:(YMAGoodsCell *)cell withObject:(YMAGoods *)goods {
    cell.name.text = goods.name;
    cell.code.text = [NSString stringWithFormat:@"%d", goods.code];
    cell.price.text = [NSString stringWithFormat:@"%f", goods.price];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;

    switch (type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withObject:anObject];
            break;

        case NSFetchedResultsChangeMove:
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo =
            [[self fetchedResultsController] sections][section];

    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMAGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YMAGoodsCell"];
    YMAOrderBook *orderBook = [self.fetchedResultsController objectAtIndexPath:indexPath];
    YMAGoods *goods = orderBook.goods;
    [self configureCell:cell withObject:goods];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        YMAOrderBook *orderBook = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [[[YMADataBase sharedDataBase] managedObjectContext] deleteObject:orderBook];
    }
}


@end
