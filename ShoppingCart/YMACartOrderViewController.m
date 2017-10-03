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
#import "YMABackEnd.h"
#import "YMAGoods+CoreDataProperties.h"
#import "YMAOrderBook+CoreDataProperties.h"
#import "YMAAvailableGoodsCell.h"
#import "YMALeftMenuViewController.h"
#import "PGDrawerTransition.h"

@interface YMACartOrderViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (weak, nonatomic) IBOutlet UIButton *sendOrderButton;

@end

@implementation YMACartOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UINib *nib = [UINib nibWithNibName:@"YMAAvailableGoodsCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"YMAAvailableGoodsCell"];
    
    nib = [UINib nibWithNibName:@"YMANotAvailableGoodsCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"YMANotAvailableGoodsCell"];
    
    [self initializeFetchedResultsController];
}

-(void)viewWillAppear:(BOOL)animated {
 /*   NSPredicate *predicate = [NSPredicate predicateWithFormat:@"available == %@", @YES];
    
    self.fetchedResultsController =  [YMADataBase.sharedDataBase fetchedResultsControllerWithDataName:@"YMAOrderBook" predicate:predicate sotretByKey:@"goods"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });*/
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

- (IBAction)showMenuTapped:(id)sender {
    [YMALeftMenuViewController.sharedInstance.drawerTransition presentDrawerViewController];

}


- (IBAction)sendOrderButtonTapped:(id)sender {
    YMAOrder *order = [[YMAShopService sharedShopService] currentOrder];
    [YMABackEnd post:order];
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
           // [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withObject:anObject];
            break;

        case NSFetchedResultsChangeMove:
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}
- (IBAction)editTableTapped:(id)sender {
    [self.tableView setEditing: YES animated: YES];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo =
            [[self fetchedResultsController] sections][section];

    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YMAAvailableGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YMAAvailableGoodsCell"];
    YMAOrderBook *orderBook = [self.fetchedResultsController objectAtIndexPath:indexPath];
    YMAGoods *goods = orderBook.goods;
    cell.nameLabel.text = goods.name;
    cell.priceLabel.text = [NSString stringWithFormat:@"%d", goods.code];
    cell.priceLabel.text = [NSString stringWithFormat:@"%.f", goods.price];
    cell.image.image = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:goods.image]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        YMAOrderBook *orderBook = [self.fetchedResultsController objectAtIndexPath:indexPath];
        [[[YMADataBase sharedDataBase] managedObjectContext] deleteObject:orderBook];
    }
}


@end
