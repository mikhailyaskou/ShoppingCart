//
//  OrderBook+CoreDataProperties.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 03.08.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "OrderBook+CoreDataProperties.h"

@implementation OrderBook (CoreDataProperties)

+ (NSFetchRequest<OrderBook *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"OrderBook"];
}

@dynamic order;
@dynamic goods;

@end
