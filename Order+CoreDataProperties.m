//
//  Order+CoreDataProperties.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 03.08.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "Order+CoreDataProperties.h"

@implementation Order (CoreDataProperties)

+ (NSFetchRequest<Order *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Order"];
}

@dynamic date;
@dynamic orderId;
@dynamic state;
@dynamic bookOrders;
@dynamic user;

@end
