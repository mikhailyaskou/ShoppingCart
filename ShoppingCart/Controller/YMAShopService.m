//
//  YMAShopService.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 29.07.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAShopService.h"
#import "YMADataBase.h"
#import "YMAGoods+CoreDataClass.h"
#import "YMAUser+CoreDataClass.h"
#import "YMAOrder+CoreDataClass.h"
#import "YMAOrderBook+CoreDataProperties.h"


@interface YMAShopService ()

@property (nonatomic, strong) YMAUser *currentUser;
@property (nonatomic, strong) YMAOrder *currentOrder;

@end

@implementation YMAShopService

+ (id)sharedShopService {
    static YMAShopService *sharedShopService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedShopService = [[self alloc] init];

    });
    return sharedShopService;
}

- (void)removeFromCar:(YMAGoods *)product {
    [self.cart removeObject:product];
}

- (YMAUser *)currentUser {

    if (!_currentUser) {

        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"YMAUser" inManagedObjectContext:[[YMADataBase sharedDataBase] managedObjectContext]];
        [fetchRequest setEntity:entity];
        // Specify criteria for filtering which objects to fetch
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", @"Igor"];
        [fetchRequest setPredicate:predicate];

        NSError *error = nil;
        NSArray *fetchedObjects = [[[YMADataBase sharedDataBase] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        //creating new user
        if (fetchedObjects.count == 0) {

            _currentUser = (YMAUser *) [NSEntityDescription insertNewObjectForEntityForName:@"YMAUser" inManagedObjectContext:[[YMADataBase sharedDataBase] managedObjectContext]];
            _currentUser.name = @"Igor";
            [[YMADataBase sharedDataBase] saveContext];
        }
        else {
            _currentUser = [fetchedObjects objectAtIndex:0];
        }
    }
    return _currentUser;
}

- (void)addToCart:(YMAGoods *)product {

    YMAOrderBook *orderBook = [NSEntityDescription insertNewObjectForEntityForName:@"YMAOrderBook" inManagedObjectContext:[[YMADataBase sharedDataBase] managedObjectContext]];
    orderBook.goods = product;
    [self.currentOrder addBookOrdersObject:orderBook];
    [[YMADataBase sharedDataBase] saveContext];
}

- (YMAOrder *)currentOrder {

    YMAOrder *openOrder = nil;

    NSSet *orders = [self.currentUser orders];
    for (YMAOrder *order in orders) {
        NSInteger *state = order.state;
        if (state == 0) {
            openOrder = order;
        }
    }

    //if no open order - creating new order
    if (!openOrder) {
        openOrder = [NSEntityDescription insertNewObjectForEntityForName:@"YMAOrder" inManagedObjectContext:[[YMADataBase sharedDataBase] managedObjectContext]];
        openOrder.date = [NSDate date];
        openOrder.state = 0;
        [self.currentUser addOrdersObject:openOrder];
    }

    return openOrder;
}

- (NSArray *)goodsFromOrder:(YMAOrder *)order {
    return order.bookOrders.allObjects;
}

- (YMAGoods *)goodsById:(NSNumber *)idGoods {
    NSManagedObjectContext *context = [[YMADataBase sharedDataBase] managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"YMAGoods" inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"code == %@", [idGoods stringValue]];
    [fetchRequest setPredicate:predicate];
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        return nil;
    }
    return fetchedObjects.firstObject;
}


@end
