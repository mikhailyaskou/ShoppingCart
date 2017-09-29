//
//  YMAOrder+CoreDataProperties.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 28.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAOrder+CoreDataProperties.h"

@implementation YMAOrder (CoreDataProperties)

+ (NSFetchRequest<YMAOrder *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"YMAOrder"];
}

@dynamic date;
@dynamic orderId;
@dynamic state;
@dynamic bookOrders;
@dynamic user;

@end
