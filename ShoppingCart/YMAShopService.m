//
//  YMAShopService.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 29.07.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAShopService.h"
#import "YMADataBase.h"
#import "Goods+CoreDataProperties.h"
#import "OrderBook+CoreDataProperties.h"
#import "Order+CoreDataProperties.h"


@interface YMAShopService ()

@property (nonatomic, strong) User* currentUser;
@property (nonatomic, strong) Order* currentOrder;

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

-(void)removeFromCar:(Goods *)product {
    [self.cart removeObject:product];
}

- (User *)currentUser {
    
    if (!_currentUser) {
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"User" inManagedObjectContext:[[YMADataBase sharedDataBase] managedObjectContext]];
        [fetchRequest setEntity:entity];
        // Specify criteria for filtering which objects to fetch
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name = %@", @"Igor"];
        [fetchRequest setPredicate:predicate];
        
        NSError *error = nil;
        NSArray *fetchedObjects = [[[YMADataBase sharedDataBase] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
        if (fetchedObjects == nil) {
            NSLog(@"%@",[error localizedDescription]);
        }
        
        //creating new user
        if (fetchedObjects.count == 0) {
            
            _currentUser = (User *)[NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:[[YMADataBase sharedDataBase] managedObjectContext]];
            _currentUser.name = @"Igor";
            [[YMADataBase sharedDataBase]saveContext];
        }
        else
        {
            _currentUser = [fetchedObjects objectAtIndex:0];
        }
        
    }
    
    return _currentUser;
}

-(void)addToCart:(Goods *)product {
    
    OrderBook *orderBook = [NSEntityDescription insertNewObjectForEntityForName:@"OrderBook" inManagedObjectContext:[[YMADataBase sharedDataBase] managedObjectContext]];
    orderBook.goods = product;
    [self.currentOrder addBookOrdersObject:orderBook];
    [[YMADataBase sharedDataBase] saveContext];
}

- (Order *)currentOrder {
    
    Order *openOrder = nil;
    
    NSSet* orders = [self.currentUser orders];
    for(Order* order in orders) {
        NSInteger *state = order.state;
        if (state  == 0){
            openOrder = order;
        }
    }
    
    //if no open order - creating new order
    if (!openOrder) {
        openOrder = [NSEntityDescription insertNewObjectForEntityForName:@"Order" inManagedObjectContext:[[YMADataBase sharedDataBase] managedObjectContext]];
        openOrder.date = [NSDate date];
        openOrder.state = 0;
        [self.currentUser addOrdersObject:openOrder];
    }
    
    return openOrder;
}

- (NSArray *) goodsFromOrder:(Order *)order {
    
    return order.bookOrders.allObjects;
}

- (Goods *)goodsById:(NSNumber *) idGoods {
    NSManagedObjectContext *context = [[YMADataBase sharedDataBase]managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Goods" inManagedObjectContext:context];
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
