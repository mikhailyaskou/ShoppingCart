//
//  YMAOrderBook+CoreDataProperties.m
//  ShoppingCart
//
//  Created by Mikhail Yaskou on 28.09.17.
//  Copyright © 2017 Mikhail Yaskou. All rights reserved.
//

#import "YMAOrderBook+CoreDataProperties.h"

@implementation YMAOrderBook (CoreDataProperties)

+ (NSFetchRequest<YMAOrderBook *> *)fetchRequest {
    return [[NSFetchRequest alloc] initWithEntityName:@"YMAOrderBook"];
}

@dynamic goods;
@dynamic order;

@end
