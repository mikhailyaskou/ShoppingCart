//
//  Goods+CoreDataProperties.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 03.08.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "Goods+CoreDataProperties.h"

@implementation Goods (CoreDataProperties)

+ (NSFetchRequest<Goods *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Goods"];
}

@dynamic aviable;
@dynamic code;
@dynamic discount;
@dynamic image;
@dynamic name;
@dynamic price;
@dynamic orderBooks;

@end
