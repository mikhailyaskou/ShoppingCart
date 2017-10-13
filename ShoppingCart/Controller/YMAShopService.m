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
#import "YMABackEnd.h"
#import "YMAConstants.h"

@implementation YMAShopService

+ (id)sharedShopService {
    static YMAShopService *sharedShopService = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedShopService = [[self alloc] init];
    });
    return sharedShopService;
}

- (NSManagedObjectID *)currentUserManagedObjectID {
    NSManagedObjectContext *moc = [YMADataBase.sharedDataBase newBackgroundContext];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:YMAUserEntityName];
    // Specify criteria for filtering which objects to fetch
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", @"Mike Yaskou"];
    [request setPredicate:predicate];

    NSError *error = nil;
    NSArray *fetchedObjects = [moc executeFetchRequest:request error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"%@", [error localizedDescription]);
    }
    //creating new user
    YMAUser *user;
    if (fetchedObjects.count == 0) {
        user = [NSEntityDescription insertNewObjectForEntityForName:YMAUserEntityName inManagedObjectContext:moc];
        user.name = @"Mike Yaskou";
        [YMADataBase.sharedDataBase saveContext:moc];
    }
    else {
        user = fetchedObjects[0];
    }
    return user.objectID;
}

- (NSManagedObjectID *)currentOrderManagedObjectID {
    NSManagedObjectContext *moc = [YMADataBase.sharedDataBase newBackgroundContext];
    YMAUser *currentUser = [moc existingObjectWithID:[YMAShopService.sharedShopService currentUserManagedObjectID] error:nil];
    YMAOrder *openOrder = nil;

    NSSet *orders = [currentUser orders];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.state == %@", @(0)];
    NSSet *filteredOrders = [orders filteredSetUsingPredicate:predicate];

    if (filteredOrders.count > 0) {
        openOrder = filteredOrders.allObjects[0];
    }
    else {
        openOrder = [NSEntityDescription insertNewObjectForEntityForName:YMAOrderEntityName inManagedObjectContext:moc];
        openOrder.date = [NSDate date];
        openOrder.state = 0;
        [currentUser addOrdersObject:openOrder];
        [YMADataBase.sharedDataBase saveContext:moc];
    }
    return openOrder.objectID;
}

- (void)addToCart:(NSManagedObjectID *)productId {
    NSManagedObjectContext *moc = [YMADataBase.sharedDataBase managedObjectContext];
    YMAGoods *product = [moc existingObjectWithID:productId error:nil];
    YMAOrderBook *orderBook = [NSEntityDescription insertNewObjectForEntityForName:YMAOrderBookEntityName inManagedObjectContext:moc];
    YMAOrder *currentOrder = [moc existingObjectWithID:[self currentOrderManagedObjectID] error:nil];
    [product addOrderBooksObject:orderBook];
    [currentOrder addBookOrdersObject:orderBook];
    [YMADataBase.sharedDataBase saveContext:moc];
}

- (void)sendCurrentOrder {
    NSManagedObjectID *orderManagedObjectID = [self currentOrderManagedObjectID];
    NSManagedObjectContext *moc = [YMADataBase.sharedDataBase managedObjectContext];
    YMAOrder *order = [moc existingObjectWithID:orderManagedObjectID error:nil];
    order.state = 1;
    [YMABackEnd post:order];
    [order removeBookOrders:order.bookOrders];
    [moc deleteObject:order];
    [YMADataBase.sharedDataBase saveContext:moc];
}

- (NSDecimalNumber *)totalOrderPrice:(YMAOrder *)order {
    NSDecimalNumber *totalPrice = NSDecimalNumber.zero;
    for (YMAOrderBook *orderBook in order.bookOrders.allObjects) {
        NSDecimalNumber *dn = [NSDecimalNumber decimalNumberWithDecimal:[@(orderBook.goods.price) decimalValue]];
        totalPrice = [totalPrice decimalNumberByAdding:dn];
    }
    return totalPrice;
}

@end
