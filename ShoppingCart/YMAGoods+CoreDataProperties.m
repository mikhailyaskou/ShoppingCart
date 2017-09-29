//
//  YMAGoods+CoreDataProperties.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 28.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAGoods+CoreDataProperties.h"

@implementation YMAGoods (CoreDataProperties)

+ (NSFetchRequest<YMAGoods *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"YMAGoods"];
}

@dynamic aviable;
@dynamic code;
@dynamic discount;
@dynamic image;
@dynamic name;
@dynamic price;
@dynamic orderBooks;

@end
